`timescale 1ns/1ps

module checksum_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    wire [3:0] checksum_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    checksum dut (
        .data_in(data_in),
        .checksum_out(checksum_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All zeros", test_num);
            data_in = 16'h0000;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: All ones", test_num);
            data_in = 16'hFFFF;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Single bit set (LSB)", test_num);
            data_in = 16'h0001;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: 15 bits set", test_num);
            data_in = 16'h7FFF;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Pattern 0x5555", test_num);
            data_in = 16'h5555;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Pattern 0xAAAA", test_num);
            data_in = 16'hAAAA;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Pattern 0x0F0F", test_num);
            data_in = 16'h0F0F;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Mixed bits 0x1234", test_num);
            data_in = 16'h1234;

            #1;


            check_outputs(4'd5);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: High bits 0xFEDC", test_num);
            data_in = 16'hFEDC;

            #1;


            check_outputs(4'd12);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Single bit set (MSB)", test_num);
            data_in = 16'h8000;
            #1;

            check_outputs(4'd1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("checksum Testbench");
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
        input [3:0] expected_checksum_out;
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
