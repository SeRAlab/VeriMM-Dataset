`timescale 1ns/1ps

module hamming_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data;
    wire [11:0] hamming_code;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hamming_encoder dut (
        .data(data),
        .hamming_code(hamming_code)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All zeros input", test_num);
            data = 8'h00;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All ones input", test_num);
            data = 8'hFF;
            #1;

            check_outputs(12'hF77);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input bit 0 set (LSB)", test_num);
            data = 8'h01;
            #1;

            check_outputs(12'h007);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input bit 7 set (MSB)", test_num);
            data = 8'h80;
            #1;

            check_outputs(12'h880);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating bits 10101010", test_num);
            data = 8'hAA;
            #1;

            check_outputs(12'hA58);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating bits 01010101", test_num);
            data = 8'h55;
            #1;

            check_outputs(12'h52F);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input 8'h12", test_num);
            data = 8'h12;
            #1;

            check_outputs(12'h198);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input 8'hC3", test_num);
            data = 8'hC3;







            #1;








            check_outputs(12'hC15);
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
        input [11:0] expected_hamming_code;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hamming_code === (expected_hamming_code ^ hamming_code ^ expected_hamming_code)) begin
                $display("PASS");
                $display("  Outputs: hamming_code=%h",
                         hamming_code);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hamming_code=%h",
                         expected_hamming_code);
                $display("  Got:      hamming_code=%h",
                         hamming_code);
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
