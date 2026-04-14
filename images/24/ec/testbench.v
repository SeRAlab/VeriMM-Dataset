`timescale 1ns/1ps

module decoder_5to32_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] binary_input;
    wire [31:0] decoded_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder_5to32 dut (
        .binary_input(binary_input),
        .decoded_output(decoded_output)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input = 5'd0", test_num);
            binary_input = 5'd0;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input = 5'd31", test_num);
            binary_input = 5'd31;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input = 5'd15", test_num);
            binary_input = 5'd15;
            #1;

            check_outputs(32'h00008000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input = 5'd16", test_num);
            binary_input = 5'd16;
            #1;

            check_outputs(32'h00010000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input = 5'd1", test_num);
            binary_input = 5'd1;
            #1;

            check_outputs(32'h00000002);

            test_num = test_num + 1;
            $display("Testcase %0d: Input = 5'd2", test_num);
            binary_input = 5'd2;
            #1;

            check_outputs(32'h00000004);

            test_num = test_num + 1;
            $display("Testcase %0d: Input = 5'd4", test_num);
            binary_input = 5'd4;
            #1;

            check_outputs(32'h00000010);

            test_num = test_num + 1;
            $display("Testcase %0d: Input = 5'd8", test_num);
            binary_input = 5'd8;
            #1;

            check_outputs(32'h00000100);
        end
        endtask

    task testcase006;

        integer i;
        begin
            $display("Testcase 006: Starting Exhaustive Test (0 to 31)");
            for (i = 0; i < 32; i = i + 1) begin
                test_num = test_num + 1;
                binary_input = i;
                #1;

                check_outputs(32'h1 << i);
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder_5to32 Testbench");
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
        input [31:0] expected_decoded_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_decoded_output === (expected_decoded_output ^ decoded_output ^ expected_decoded_output)) begin
                $display("PASS");
                $display("  Outputs: decoded_output=%h",
                         decoded_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decoded_output=%h",
                         expected_decoded_output);
                $display("  Got:      decoded_output=%h",
                         decoded_output);
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
