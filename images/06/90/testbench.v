`timescale 1ns/1ps

module reed_solomon_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_in;
    wire [7:0] encoded_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reed_solomon_encoder dut (
        .data_in(data_in),
        .encoded_out(encoded_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Zero Input", test_num);
            data_in = 4'b0000;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Input 4'h1", test_num);
            data_in = 4'b0001;



            #1;




            check_outputs({4'h1, 4'h7});
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Input 4'h2", test_num);
            data_in = 4'b0010;
            #1;

            check_outputs({4'h2, 4'hE});
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Input 4'h4", test_num);
            data_in = 4'b0100;
            #1;

            check_outputs({4'h4, 4'hD});
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Input 4'h8", test_num);
            data_in = 4'b1000;
            #1;

            check_outputs({4'h8, 4'hB});
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: All Ones", test_num);
            data_in = 4'b1111;
            #1;

            check_outputs({4'hF, 4'h1});
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Input 4'hA (1010)", test_num);
            data_in = 4'b1010;
            #1;

            check_outputs({4'hA, 4'h5});
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Input 4'h5 (0101)", test_num);
            data_in = 4'b0101;
            #1;

            check_outputs({4'h5, 4'hA});
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Input 4'hC (1100)", test_num);
            data_in = 4'b1100;
            #1;

            check_outputs({4'hC, 4'h6});
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Input 4'h3 (0011)", test_num);
            data_in = 4'b0011;
            #1;

            check_outputs({4'h3, 4'h9});
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reed_solomon_encoder Testbench");
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
        input [7:0] expected_encoded_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_encoded_out === (expected_encoded_out ^ encoded_out ^ expected_encoded_out)) begin
                $display("PASS");
                $display("  Outputs: encoded_out=%h",
                         encoded_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_out=%h",
                         expected_encoded_out);
                $display("  Got:      encoded_out=%h",
                         encoded_out);
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
