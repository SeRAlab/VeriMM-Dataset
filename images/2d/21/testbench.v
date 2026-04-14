`timescale 1ns/1ps

module black_scholes_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] risk_free_rate;
    reg rst;
    reg [31:0] stock_price;
    reg [31:0] strike_price;
    reg [31:0] time_to_expiry;
    reg [31:0] volatility;
    wire [31:0] option_price;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    black_scholes dut (
        .clk(clk),
        .risk_free_rate(risk_free_rate),
        .rst(rst),
        .stock_price(stock_price),
        .strike_price(strike_price),
        .time_to_expiry(time_to_expiry),
        .volatility(volatility),
        .option_price(option_price)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            stock_price = 0;
            strike_price = 0;
            risk_free_rate = 0;
            time_to_expiry = 0;
            volatility = 0;
            repeat(10) @(posedge clk);
            rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %0d: At-the-Money (S=100, K=100, r=0.05, t=1.0, vol=0.2)", test_num);
            stock_price    = 32'h00640000;
            strike_price   = 32'h00640000;
            risk_free_rate = 32'h00000CCD;
            time_to_expiry = 32'h00010000;
            volatility     = 32'h00003333;

            repeat(500) @(posedge clk);
            #1;

            check_outputs(32'h000A735A);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %0d: Out-of-the-Money (S=80, K=100, r=0.05, t=1.0, vol=0.2)", test_num);
            stock_price    = 32'h00500000;
            strike_price   = 32'h00640000;
            risk_free_rate = 32'h00000CCD;
            time_to_expiry = 32'h00010000;
            volatility     = 32'h00003333;

            repeat(500) @(posedge clk);
            #1;

            check_outputs(32'h0001DB64);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %0d: In-the-Money (S=120, K=100, r=0.05, t=1.0, vol=0.2)", test_num);
            stock_price    = 32'h00780000;
            strike_price   = 32'h00640000;
            risk_free_rate = 32'h00000CCD;
            time_to_expiry = 32'h00010000;
            volatility     = 32'h00003333;

            repeat(500) @(posedge clk);
            #1;

            check_outputs(32'h001A2A3D);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %0d: High Volatility (S=100, K=100, r=0.05, t=1.0, vol=0.5)", test_num);
            stock_price    = 32'h00640000;
            strike_price   = 32'h00640000;
            risk_free_rate = 32'h00000CCD;
            time_to_expiry = 32'h00010000;
            volatility     = 32'h00008000;

            repeat(500) @(posedge clk);
            #1;

            check_outputs(32'h00143D70);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %0d: Short Expiry (S=110, K=100, r=0.05, t=0.083, vol=0.2)", test_num);
            stock_price    = 32'h006E0000;
            strike_price   = 32'h00640000;
            risk_free_rate = 32'h00000CCD;
            time_to_expiry = 32'h0000154F;
            volatility     = 32'h00003333;

            repeat(500) @(posedge clk);
            #1;

            check_outputs(32'h000A6B85);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("black_scholes Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [31:0] expected_option_price;
        begin
            if (expected_option_price === (expected_option_price ^ option_price ^ expected_option_price)) begin
                $display("PASS");
                $display("  Outputs: option_price=%h",
                         option_price);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: option_price=%h",
                         expected_option_price);
                $display("  Got:      option_price=%h",
                         option_price);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, risk_free_rate, rst, stock_price, strike_price, time_to_expiry, volatility, option_price);
    end

endmodule
