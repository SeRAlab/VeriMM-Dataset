`timescale 1ns/1ps

module morphological_dilation_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] img;
    reg [8:0] se;
    wire [8:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    morphological_dilation dut (
        .img(img),
        .se(se),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            img = 9'h000;
            se = 9'h1FF;
            $display("Test %0d: All Zeros Image (Result should be 0)", test_num);
            #1;

            check_outputs(9'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            img = 9'h155;
            se = 9'h010;
            $display("Test %0d: Identity Structuring Element", test_num);
            #1;

            check_outputs(9'h155);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            img = 9'h010;
            se = 9'h1FF;
            $display("Test %0d: Center Pixel Expansion to Full Matrix", test_num);
            #1;

            check_outputs(9'h1FF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            img = 9'h100;
            se = 9'h1FF;
            $display("Test %0d: Top-Left Corner Expansion", test_num);


            #1;



            check_outputs(9'h1B0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            img = 9'h001;
            se = 9'h1FF;
            $display("Test %0d: Bottom-Right Corner Expansion", test_num);


            #1;



            check_outputs(9'h01B);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            img = 9'h010;
            se = 9'h0BA;
            $display("Test %0d: Center Pixel with Cross-Shaped SE", test_num);
            #1;

            check_outputs(9'h0BA);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            img = 9'h1FF;
            se = 9'h010;
            $display("Test %0d: Full Image with Identity SE", test_num);
            #1;

            check_outputs(9'h1FF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            img = 9'h101;
            se = 9'h1FF;
            $display("Test %0d: Multiple Points Expansion Overlap", test_num);


            #1;



            check_outputs(9'h1BB);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("morphological_dilation Testbench");
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
        input [8:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
