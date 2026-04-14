`timescale 1ns/1ps

module bin_to_gray_6bit_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] B;
    wire [5:0] G;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bin_to_gray_6bit dut (
        .B(B),
        .G(G)
    );
    task testcase001;

        begin
            test_num = 1;
            B = 6'b000000;
            $display("Test %0d: Input Binary = %b", test_num, B);
            #1;

            check_outputs(6'b000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            B = 6'b000001;
            $display("Test %0d: Input Binary = %b", test_num, B);
            #1;

            check_outputs(6'b000001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            B = 6'b000010;
            $display("Test %0d: Input Binary = %b", test_num, B);
            #1;

            check_outputs(6'b000011);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            B = 6'b000011;
            $display("Test %0d: Input Binary = %b", test_num, B);
            #1;

            check_outputs(6'b000010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            B = 6'b000111;
            $display("Test %0d: Input Binary = %b", test_num, B);
            #1;

            check_outputs(6'b000100);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            B = 6'b011111;
            $display("Test %0d: Input Binary = %b", test_num, B);
            #1;

            check_outputs(6'b010000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            B = 6'b100000;
            $display("Test %0d: Input Binary = %b", test_num, B);
            #1;

            check_outputs(6'b110000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            B = 6'b101010;
            $display("Test %0d: Input Binary = %b", test_num, B);
            #1;

            check_outputs(6'b111111);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            B = 6'b010101;
            $display("Test %0d: Input Binary = %b", test_num, B);
            #1;

            check_outputs(6'b011111);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            B = 6'b111111;
            $display("Test %0d: Input Binary = %b", test_num, B);
            #1;

            check_outputs(6'b100000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bin_to_gray_6bit Testbench");
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
        input [5:0] expected_G;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_G === (expected_G ^ G ^ expected_G)) begin
                $display("PASS");
                $display("  Outputs: G=%h",
                         G);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: G=%h",
                         expected_G);
                $display("  Got:      G=%h",
                         G);
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
