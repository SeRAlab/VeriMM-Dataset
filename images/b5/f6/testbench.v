`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [99:0] in_port;
    reg reset;
    wire [99:0] out_port;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .in_port(in_port),
        .reset(reset),
        .out_port(out_port)
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
        in_port = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verifying reset clears output to zero", test_num);
        reset_dut();


        #1;



        check_outputs(100'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verifying data transfer with enable=1", test_num);
        reset_dut();
        in_port = 100'hAAAAA_BBBBB_CCCCC_DDDDD_EEEEE;
        enable = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(100'hAAAAA_BBBBB_CCCCC_DDDDD_EEEEE);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verifying output hold when enable=0", test_num);
        reset_dut();


        in_port = 100'h55555_55555_55555_55555_55555;
        enable = 1;
        @(posedge clk);
        #1;


        enable = 0;
        in_port = 100'hFFFFF_FFFFF_FFFFF_FFFFF_FFFFF;
        @(posedge clk);
        #1;


        #1;



        check_outputs(100'h55555_55555_55555_55555_55555);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verifying transfer of all ones", test_num);
        reset_dut();
        in_port = {100{1'b1}};
        enable = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs({100{1'b1}});
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verifying reset priority over enable", test_num);
        reset_dut();


        in_port = 100'h12345_67890_ABCDE_F1234_56789;
        enable = 1;
        reset = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(100'd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [99:0] expected_out_port;
        begin
            if (expected_out_port === (expected_out_port ^ out_port ^ expected_out_port)) begin
                $display("PASS");
                $display("  Outputs: out_port=%h",
                         out_port);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_port=%h",
                         expected_out_port);
                $display("  Got:      out_port=%h",
                         out_port);
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
        $dumpvars(0,clk, enable, in_port, reset, out_port);
    end

endmodule
