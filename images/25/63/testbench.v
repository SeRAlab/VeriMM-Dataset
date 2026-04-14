`timescale 1ns/1ps

module rgb_to_grayscale_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [7:0] C;
    wire [7:0] gray;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rgb_to_grayscale dut (
        .A(A),
        .B(B),
        .C(C),
        .gray(gray)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros (Black)", test_num);
            A = 8'd0; B = 8'd0; C = 8'd0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Max (White)", test_num);
            A = 8'd255; B = 8'd255; C = 8'd255;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pure Red (Round Down)", test_num);
            A = 8'd255; B = 8'd0; C = 8'd0;
            #1;

            check_outputs(8'd76);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pure Green (Round Up)", test_num);
            A = 8'd0; B = 8'd255; C = 8'd0;
            #1;

            check_outputs(8'd150);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pure Blue (Round Down)", test_num);
            A = 8'd0; B = 8'd0; C = 8'd255;
            #1;

            check_outputs(8'd29);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed Values (Round Down)", test_num);
            A = 8'd128; B = 8'd64; C = 8'd32;
            #1;

            check_outputs(8'd79);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed Values (Round Up)", test_num);
            A = 8'd100; B = 8'd150; C = 8'd200;
            #1;

            check_outputs(8'd141);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Yellow (Red + Green, Round Up)", test_num);
            A = 8'd255; B = 8'd255; C = 8'd0;
            #1;

            check_outputs(8'd226);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Cyan (Green + Blue, Round Down)", test_num);
            A = 8'd0; B = 8'd255; C = 8'd255;
            #1;

            check_outputs(8'd179);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Low Values", test_num);
            A = 8'd10; B = 8'd20; C = 8'd30;
            #1;

            check_outputs(8'd18);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rgb_to_grayscale Testbench");
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
        input [7:0] expected_gray;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_gray === (expected_gray ^ gray ^ expected_gray)) begin
                $display("PASS");
                $display("  Outputs: gray=%h",
                         gray);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gray=%h",
                         expected_gray);
                $display("  Got:      gray=%h",
                         gray);
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
