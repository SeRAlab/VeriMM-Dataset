`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in;
    wire [30:0] out_any;
    wire [30:0] out_both;
    wire [31:0] out_different;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out_any(out_any),
        .out_both(out_both),
        .out_different(out_different)
    );
    task testcase001;

    begin
        test_num = 1;
        in = 32'h00000000;

        #1;


        check_outputs(31'h0, 31'h0, 32'h0);
    end
    endtask

    task testcase002;

    begin
        test_num = 2;
        in = 32'hFFFFFFFF;



        #1;




        check_outputs(31'h7FFFFFFF, 31'h7FFFFFFF, 32'h0);
    end
    endtask

    task testcase003;

    begin
        test_num = 3;
        in = 32'hAAAAAAAA;



        #1;




        check_outputs(31'h7FFFFFFE, 31'h0, 32'hFFFFFFFF);
    end
    endtask

    task testcase004;

    begin
        test_num = 4;
        in = 32'h55555555;



        #1;




        check_outputs(31'h7FFFFFFE, 31'h0, 32'hFFFFFFFF);
    end
    endtask

    task testcase005;

    begin
        test_num = 5;
        in = 32'h00000003;



        #1;




        check_outputs(31'h00000006, 31'h00000001, 32'h00000002);
    end
    endtask

    task testcase006;

    begin
        test_num = 6;
        in = 32'h80000001;



        #1;




        check_outputs(31'h40000002, 31'h0, 32'h40000001);
    end
    endtask

    task testcase007;

    begin
        test_num = 7;
        in = 32'hC0000003;



        #1;




        check_outputs(31'h40000006, 31'h40000001, 32'h20000002);
    end
    endtask

    task testcase008;

    begin
        test_num = 8;
        in = 32'h12345678;





        #1;






        check_outputs(31'h1B3E7F7C, 31'h00100238, 32'h1B2E7D44);
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
        input [30:0] expected_out_any;
        input [30:0] expected_out_both;
        input [31:0] expected_out_different;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_any === (expected_out_any ^ out_any ^ expected_out_any) &&
                expected_out_both === (expected_out_both ^ out_both ^ expected_out_both) &&
                expected_out_different === (expected_out_different ^ out_different ^ expected_out_different)) begin
                $display("PASS");
                $display("  Outputs: out_any=%h, out_both=%h, out_different=%h",
                         out_any, out_both, out_different);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_any=%h, out_both=%h, out_different=%h",
                         expected_out_any, expected_out_both, expected_out_different);
                $display("  Got:      out_any=%h, out_both=%h, out_different=%h",
                         out_any, out_both, out_different);
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

endmodule
