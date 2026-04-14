`timescale 1ns/1ps

module ip_checksum_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    reg [15:0] data_in2;
    wire [15:0] checksum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ip_checksum dut (
        .data_in(data_in),
        .data_in2(data_in2),
        .checksum(checksum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros", test_num);
            data_in = 16'h0000;
            data_in2 = 16'h0000;

            #1;


            check_outputs(16'hFFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: One Word Max, One Zero", test_num);
            data_in = 16'hFFFF;
            data_in2 = 16'h0000;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Wrap Around Carry (Minimum)", test_num);
            data_in = 16'hFFFF;
            data_in2 = 16'h0001;

            #1;


            check_outputs(16'hFFFE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Sum No Carry", test_num);
            data_in = 16'h1234;
            data_in2 = 16'h4321;

            #1;


            check_outputs(16'hAAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Wrap Around Carry (Middle)", test_num);
            data_in = 16'h8000;
            data_in2 = 16'h8000;

            #1;


            check_outputs(16'hFFFE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Bits Resulting in Zero Checksum", test_num);
            data_in = 16'hAAAA;
            data_in2 = 16'h5555;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum Possible Carry Wrap", test_num);
            data_in = 16'hFFFF;
            data_in2 = 16'hFFFF;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: High-order Carry Bits", test_num);
            data_in = 16'hF000;
            data_in2 = 16'hF000;

            #1;


            check_outputs(16'h1FFE);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random Pattern 1", test_num);
            data_in = 16'h1234;
            data_in2 = 16'hABCD;

            #1;


            check_outputs(16'h41FE);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random Pattern 2", test_num);
            data_in = 16'h4567;
            data_in2 = 16'hDCBA;

            #1;


            check_outputs(16'hDDDD);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ip_checksum Testbench");
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
        input [15:0] expected_checksum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_checksum === (expected_checksum ^ checksum ^ expected_checksum)) begin
                $display("PASS");
                $display("  Outputs: checksum=%h",
                         checksum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum=%h",
                         expected_checksum);
                $display("  Got:      checksum=%h",
                         checksum);
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
