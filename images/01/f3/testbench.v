`timescale 1ns/1ps

module hamming_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    wire [19:0] codeword;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hamming_encoder dut (
        .data_in(data_in),
        .codeword(codeword)
    );
    task check_case;

        input [15:0] test_data;
        input [19:0] expected_code;
        begin
            test_num = test_num + 1;
            data_in = test_data;
            #1;
            $display("Test Case %0d: Input=%h", test_num, test_data);
            #1;

            check_outputs(expected_code);
        end
        endtask

    task testcase001;

        begin

            check_case(16'h0000, 20'h00000);
        end
        endtask

    task testcase002;

        begin



            check_case(16'h0001, 20'h00007);
        end
        endtask

    task testcase003;

        begin



            check_case(16'h0002, 20'h00019);
        end
        endtask

    task testcase004;

        begin





            check_case(16'h0004, 20'h00026);
        end
        endtask

    task testcase005;

        begin


            check_case(16'h0008, 20'h0004B);
        end
        endtask

    task testcase006;

        begin


            check_case(16'h0010, 20'h00181);
        end
        endtask

    task testcase007;

        begin


            check_case(16'hFFFF, 20'hFFFF7);
        end
        endtask

    task testcase008;

        begin

            check_case(16'hAAAA, 20'hAAAD8);
        end
        endtask

    task testcase009;

        begin

            check_case(16'h5555, 20'h5552F);
        end
        endtask

    task testcase010;

        begin

            check_case(16'h1234, 20'h123A2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hamming_encoder Testbench");
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
        input [19:0] expected_codeword;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_codeword === (expected_codeword ^ codeword ^ expected_codeword)) begin
                $display("PASS");
                $display("  Outputs: codeword=%h",
                         codeword);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: codeword=%h",
                         expected_codeword);
                $display("  Got:      codeword=%h",
                         codeword);
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
