`timescale 1ns/1ps

module ip_checksum_calculator_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data_in;
    wire [15:0] checksum_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ip_checksum_calculator dut (
        .data_in(data_in),
        .checksum_out(checksum_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Simple addition without carry", test_num);
            data_in = 32'h1234_5678;

            #1;


            check_outputs(16'h9753);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Addition with carry-out (Wrap around)", test_num);
            data_in = 32'hFFFF_0001;

            #1;


            check_outputs(16'hFFFE);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: All zeros input", test_num);
            data_in = 32'h0000_0000;

            #1;


            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: All ones input (Maximum wrap around)", test_num);
            data_in = 32'hFFFF_FFFF;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Random data with carry", test_num);
            data_in = 32'hABCD_1234;

            #1;


            check_outputs(16'h41FE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Large values resulting in carry", test_num);
            data_in = 32'hF000_F000;

            #1;


            check_outputs(16'h1FFE);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Standard IP header start values", test_num);
            data_in = 32'h4500_003C;

            #1;


            check_outputs(16'hBAC3);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Resulting in zero before complement", test_num);


            data_in = 32'hAAAA_5555;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ip_checksum_calculator Testbench");
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
        input [15:0] expected_checksum_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_checksum_out === (expected_checksum_out ^ checksum_out ^ expected_checksum_out)) begin
                $display("PASS");
                $display("  Outputs: checksum_out=%h",
                         checksum_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum_out=%h",
                         expected_checksum_out);
                $display("  Got:      checksum_out=%h",
                         checksum_out);
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
