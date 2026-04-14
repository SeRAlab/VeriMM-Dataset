`timescale 1ns/1ps

module priority_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] in;
    wire [2:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder dut (
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: No inputs active", test_num);
            in = 5'b00000;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Input 0 active (Highest Priority)", test_num);
            in = 5'b00001;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Input 1 active", test_num);
            in = 5'b00010;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Input 2 active", test_num);
            in = 5'b00100;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Input 3 active", test_num);
            in = 5'b01000;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Input 4 active (Lowest Priority)", test_num);
            in = 5'b10000;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Multiple inputs, 0 dominates", test_num);
            in = 5'b11111;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Multiple inputs, 1 dominates", test_num);
            in = 5'b11110;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Multiple inputs, 2 dominates", test_num);
            in = 5'b11100;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Multiple inputs, 3 dominates", test_num);
            in = 5'b11000;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Sparse inputs, 1 and 4 active", test_num);
            in = 5'b10010;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Sparse inputs, 2 and 4 active", test_num);
            in = 5'b10100;
            #1;

            check_outputs(3'b010);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("priority_encoder Testbench");
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
        testcase011();
        testcase012();
        
        
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
        input [2:0] expected_out;
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
