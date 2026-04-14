`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] w2;
    reg [2:0] w3;
    reg [6:0] w4;
    wire [2:0] v36f80c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .w2(w2),
        .w3(w3),
        .w4(w4),
        .v36f80c(v36f80c)
    );
    task testcase001;

        begin
            test_num = 1;
            w3 = 3'd0;
            w2 = 3'b111;
            w4 = 7'b1010101;

            #1;


            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            w3 = 3'd1;
            w2 = 3'b001;
            w4 = 7'b0000000;



            #1;




            check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            w3 = 3'd2;
            w2 = 3'b010;
            w4 = 7'b0000000;

            #1;


            check_outputs(3'b010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            w3 = 3'd3;
            w2 = 3'b100;
            w4 = 7'b0000000;

            #1;


            check_outputs(3'b100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            w3 = 3'd4;
            w2 = 3'b000;
            w4 = 7'b0000111;


            #1;



            check_outputs(3'b111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            w3 = 3'd5;
            w2 = 3'b000;
            w4 = 7'b0001010;

            #1;


            check_outputs(3'b010);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            w3 = 3'd6;
            w2 = 3'b000;
            w4 = 7'b0110000;

            #1;


            check_outputs(3'b110);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            w3 = 3'd7;
            w2 = 3'b000;
            w4 = 7'b1011011;

            #1;


            check_outputs(3'b011);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            w3 = 3'd0;
            w2 = 3'b000;
            w4 = 7'b1111111;

            #1;


            check_outputs(3'b000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            w3 = 3'd1;
            w2 = 3'b111;
            w4 = 7'b0000000;

            #1;


            check_outputs(3'b111);
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
        testcase009();
        testcase010();
        
        
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
        input [2:0] expected_v36f80c;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_v36f80c === (expected_v36f80c ^ v36f80c ^ expected_v36f80c)) begin
                $display("PASS");
                $display("  Outputs: v36f80c=%h",
                         v36f80c);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: v36f80c=%h",
                         expected_v36f80c);
                $display("  Got:      v36f80c=%h",
                         v36f80c);
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
