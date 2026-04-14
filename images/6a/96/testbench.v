`timescale 1ns/1ps

module register_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg ena;
    reg rst;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_32bit dut (
        .clk(clk),
        .data_in(data_in),
        .ena(ena),
        .rst(rst),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        ena = 0;
        data_in = 32'h0;
        @(posedge clk);
        #1;
        rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Verifying reset state", test_num);
        reset_dut();

        #1;


        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Writing data with Enable=1", test_num);
        reset_dut();

        data_in = 32'hDEADBEEF;
        ena = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Writing data with Enable=0", test_num);
        reset_dut();

        data_in = 32'h12345678;
        ena = 0;
        @(posedge clk);
        #1;


        #1;



        check_outputs(32'h00000000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Holding value when Enable is de-asserted", test_num);
        reset_dut();


        data_in = 32'hAAAA_BBBB;
        ena = 1;
        @(posedge clk);
        #1;


        data_in = 32'hCCCC_DDDD;
        ena = 0;
        @(posedge clk);
        #1;


        #1;



        check_outputs(32'hAAAA_BBBB);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Verifying Reset priority over Enable", test_num);
        reset_dut();


        data_in = 32'hFFFF_FFFF;
        ena = 1;
        @(posedge clk);
        #1;


        rst = 1;
        ena = 1;
        data_in = 32'h1111_2222;
        @(posedge clk);
        #1;


        #1;



        check_outputs(32'h00000000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Testing boundary value (All Ones)", test_num);
        reset_dut();

        data_in = 32'hFFFF_FFFF;
        ena = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Changing data multiple times with Enable", test_num);
        reset_dut();

        ena = 1;
        data_in = 32'h0000_0001;
        @(posedge clk);
        #1;
        data_in = 32'h0000_0002;
        @(posedge clk);
        #1;
        data_in = 32'h0000_0003;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h0000_0003);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register_32bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [31:0] expected_q;
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
        $dumpvars(0,clk, data_in, ena, rst, q);
    end

endmodule
