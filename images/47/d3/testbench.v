`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] p;
    reg [15:0] q;
    wire [15:0] out_not;
    wire [15:0] out_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .p(p),
        .q(q),
        .out_not(out_not),
        .out_xor(out_xor)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All zeros", test_num);
            p = 16'h0000;
            q = 16'h0000;


            #1;



            check_outputs(16'hFFFF, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All ones", test_num);
            p = 16'hFFFF;
            q = 16'hFFFF;


            #1;



            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating bits (XOR check)", test_num);
            p = 16'hAAAA;
            q = 16'h5555;


            #1;



            check_outputs(16'h5555, 16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Upper and lower nibble check", test_num);
            p = 16'hF0F0;
            q = 16'h0F0F;


            #1;



            check_outputs(16'h0F0F, 16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random pattern check", test_num);
            p = 16'h1234;
            q = 16'hABCD;


            #1;



            check_outputs(16'hEDCB, 16'hB9F9);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Symmetry check", test_num);
            p = 16'h00FF;
            q = 16'hFF00;


            #1;



            check_outputs(16'hFF00, 16'hFFFF);
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
        input [15:0] expected_out_not;
        input [15:0] expected_out_xor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_not === (expected_out_not ^ out_not ^ expected_out_not) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor)) begin
                $display("PASS");
                $display("  Outputs: out_not=%h, out_xor=%h",
                         out_not, out_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_not=%h, out_xor=%h",
                         expected_out_not, expected_out_xor);
                $display("  Got:      out_not=%h, out_xor=%h",
                         out_not, out_xor);
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
