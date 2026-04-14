`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] phase;
    wire [6:0] index_cor;
    wire [2:0] index_qua;
    wire [5:0] index_rea;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .phase(phase),
        .index_cor(index_cor),
        .index_qua(index_qua),
        .index_rea(index_rea)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros", test_num);
        phase = 16'h0000;




        #1;





        check_outputs(7'h00, 3'h0, 6'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Quadrant 1, MSB=0 (No Inversion)", test_num);
        phase = 16'h2488;






        #1;







        check_outputs(7'h12, 3'h1, 6'h08);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Quadrant 1, MSB=1 (Inversion)", test_num);
        phase = 16'h3000;





        #1;






        check_outputs(7'h3F, 3'h1, 6'h3F);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum Phase Value", test_num);
        phase = 16'hFFFF;





        #1;






        check_outputs(7'h00, 3'h7, 6'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Bits, MSB=0", test_num);
        phase = 16'h8AAA;






        #1;







        check_outputs(7'h2A, 3'h4, 6'h2A);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Bits, MSB=1", test_num);
        phase = 16'h5555;





        #1;






        check_outputs(7'h2A, 3'h2, 6'h2A);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary Inversion (Just below MSB flip)", test_num);
        phase = 16'h0FFF;




        #1;





        check_outputs(7'h3F, 3'h0, 6'h3F);
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
        input [6:0] expected_index_cor;
        input [2:0] expected_index_qua;
        input [5:0] expected_index_rea;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_index_cor === (expected_index_cor ^ index_cor ^ expected_index_cor) &&
                expected_index_qua === (expected_index_qua ^ index_qua ^ expected_index_qua) &&
                expected_index_rea === (expected_index_rea ^ index_rea ^ expected_index_rea)) begin
                $display("PASS");
                $display("  Outputs: index_cor=%h, index_qua=%h, index_rea=%h",
                         index_cor, index_qua, index_rea);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: index_cor=%h, index_qua=%h, index_rea=%h",
                         expected_index_cor, expected_index_qua, expected_index_rea);
                $display("  Got:      index_cor=%h, index_qua=%h, index_rea=%h",
                         index_cor, index_qua, index_rea);
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
