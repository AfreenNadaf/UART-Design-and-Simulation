
`timescale 1ns/1ps

module uart_tb;

    reg clk;
    reg rst;
    reg tx_start;
    reg [7:0] tx_data;

    wire tx;
    wire tx_busy;
    wire [7:0] rx_data;
    wire rx_done;

    uart_tx #(
        .CLKS_PER_BIT(868)
    ) transmitter (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    uart_rx #(
        .CLKS_PER_BIT(868)
    ) receiver (
        .clk(clk),
        .rst(rst),
        .rx(tx),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, uart_tb);
    end

    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    initial begin
        rst = 1;
        tx_start = 0;
        tx_data = 8'hA5;

        #100;
        rst = 0;

        #100;
        tx_start = 1;

        #20;
        tx_start = 0;

        wait(rx_done);
        #1;

        $display("--------------------------------");
        $display("UART SIMULATION RESULT");
        $display("Transmitted Data = %h", tx_data);
        $display("Received Data    = %h", rx_data);

        if (rx_data === tx_data)
            $display("STATUS: PASS");
        else
            $display("STATUS: FAIL");

        $display("--------------------------------");

        wait(tx_busy == 0);
        #20;
        $finish;
    end

    initial begin
        #300000;
        $display("ERROR: Simulation timeout!");
        $finish;
    end

endmodule
