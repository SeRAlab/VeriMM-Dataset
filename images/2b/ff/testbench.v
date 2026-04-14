`timescale 1ns/1ps

module turbo_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_in;
    wire [7:0] encoded_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    turbo_encoder dut (
        .data_in(data_in),
        .encoded_out(encoded_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            data_in = 4'b0000;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            data_in = 4'b1111;


            #1;



            check_outputs(8'h88);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB Only", test_num);
            data_in = 4'b1000;

            #1;


            check_outputs(8'hC1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: LSB Only", test_num);
            data_in = 4'b0001;

            #1;


            check_outputs(8'h1C);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating 1010", test_num);
            data_in = 4'b1010;

            #1;


            check_outputs(8'hF7);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating 0101", test_num);
            data_in = 4'b0101;

            #1;


            check_outputs(8'h7F);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Middle Bits 0110", test_num);
            data_in = 4'b0110;

            #1;


            check_outputs(8'h66);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bit Pattern 0010", test_num);
            data_in = 4'b0010;
            #1;

            check_outputs(8'h0311);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("turbo_encoder Testbench");
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
