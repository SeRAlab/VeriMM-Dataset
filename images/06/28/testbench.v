`timescale 1ns/1ps

module checksum_calculator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] checksum_in;
    reg [7:0] data_in;
    wire valid_checksum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    checksum_calculator dut (
        .checksum_in(checksum_in),
        .data_in(data_in),
        .valid_checksum(valid_checksum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Data=0x00, Correct Checksum=0xFF", test_num);
            data_in = 8'h00;
            checksum_in = 8'hFF;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Data=0xFF, Correct Checksum=0x00", test_num);
            data_in = 8'hFF;
            checksum_in = 8'h00;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Data=0x55, Correct Checksum=0xAA", test_num);
            data_in = 8'h55;
            checksum_in = 8'hAA;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Data=0xAA, Correct Checksum=0x55", test_num);
            data_in = 8'hAA;
            checksum_in = 8'h55;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Data=0x12, Correct Checksum=0xED", test_num);
            data_in = 8'h12;
            checksum_in = 8'hED;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Data=0x00, Incorrect Checksum=0x00", test_num);
            data_in = 8'h00;
            checksum_in = 8'h00;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Data=0xFF, Incorrect Checksum=0xFF", test_num);
            data_in = 8'hFF;
            checksum_in = 8'hFF;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Data=0x81, Correct Checksum=0x7E", test_num);
            data_in = 8'h81;
            checksum_in = 8'h7E;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Data=0x81, Incorrect Checksum=0x7F", test_num);
            data_in = 8'h81;
            checksum_in = 8'h7F;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("checksum_calculator Testbench");
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
        input expected_valid_checksum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_valid_checksum === (expected_valid_checksum ^ valid_checksum ^ expected_valid_checksum)) begin
                $display("PASS");
                $display("  Outputs: valid_checksum=%b",
                         valid_checksum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: valid_checksum=%b",
                         expected_valid_checksum);
                $display("  Got:      valid_checksum=%b",
                         valid_checksum);
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
