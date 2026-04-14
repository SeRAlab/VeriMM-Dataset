`timescale 1ns/1ps

module reg_with_enable_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg enable;
    reg reset;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg_with_enable dut (
        .clk(clk),
        .data(data),
        .enable(enable),
        .reset(reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        enable = 0;
        data = 8'h00;
        #15;
        reset = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Power-on Reset check", test_num);
        reset_dut();
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Load data 8'hAA with enable=1", test_num);
        reset_dut();
        data = 8'hAA;
        enable = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Hold data 8'h55 with enable=0", test_num);
        reset_dut();


        data = 8'h55;
        enable = 1;
        @(posedge clk);
        #2;


        data = 8'hFF;
        enable = 0;
        @(posedge clk);
        #2;

        #1;


        check_outputs(8'h55);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Overwrite data from 8'h11 to 8'h22", test_num);
        reset_dut();


        data = 8'h11;
        enable = 1;
        @(posedge clk);
        #2;


        data = 8'h22;
        @(posedge clk);
        #2;

        #1;


        check_outputs(8'h22);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Asynchronous reset during active cycle", test_num);
        reset_dut();


        data = 8'hFF;
        enable = 1;
        @(posedge clk);
        #2;


        #3;
        reset = 1;
        #2;

        #1;


        check_outputs(8'h00);
        reset = 0;
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiple data transitions with enable high", test_num);
        reset_dut();

        enable = 1;
        data = 8'h01;
        @(posedge clk);
        #2;
        data = 8'h02;
        @(posedge clk);
        #2;
        data = 8'h03;
        @(posedge clk);
        #2;

        #1;


        check_outputs(8'h03);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Verify persistence after disabling enable", test_num);
        reset_dut();

        data = 8'hCC;
        enable = 1;
        @(posedge clk);
        #2;

        enable = 0;
        data = 8'h00;
        @(posedge clk);
        @(posedge clk);
        #2;

        #1;


        check_outputs(8'hCC);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reset priority over enable and data", test_num);
        reset_dut();

        data = 8'hFF;
        enable = 1;
        reset = 1;
        #5;

        #1;


        check_outputs(8'h00);
        reset = 0;
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg_with_enable Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [7:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, data, enable, reset, q);
    end

endmodule
