`timescale 1ns/1ps

module ip_checksum_tb;

    // Testbench signals (combinational circuit)
    reg valid;
    reg [15:0] word0;
    reg [15:0] word1;
    reg [15:0] word2;
    reg [15:0] word3;
    reg [15:0] word4;
    reg [15:0] word5;
    reg [15:0] word6;
    reg [15:0] word7;
    wire [15:0] checksum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ip_checksum dut (
        .valid(valid),
        .word0(word0),
        .word1(word1),
        .word2(word2),
        .word3(word3),
        .word4(word4),
        .word5(word5),
        .word6(word6),
        .word7(word7),
        .checksum(checksum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            valid = 1'b1;
            word0 = 16'h0000;
            word1 = 16'h0000;
            word2 = 16'h0000;
            word3 = 16'h0000;
            word4 = 16'h0000;
            word5 = 16'h0000;
            word6 = 16'h0000;
            word7 = 16'h0000;

            #1;


            check_outputs(16'hFFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All FFFF (Max Values)", test_num);
            valid = 1'b1;
            word0 = 16'hFFFF;
            word1 = 16'hFFFF;
            word2 = 16'hFFFF;
            word3 = 16'hFFFF;
            word4 = 16'hFFFF;
            word5 = 16'hFFFF;
            word6 = 16'hFFFF;
            word7 = 16'hFFFF;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Incremental Values", test_num);
            valid = 1'b1;
            word0 = 16'h0001;
            word1 = 16'h0002;
            word2 = 16'h0003;
            word3 = 16'h0004;
            word4 = 16'h0005;
            word5 = 16'h0006;
            word6 = 16'h0007;
            word7 = 16'h0008;

            #1;


            check_outputs(16'hFFDB);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random IP Header-like Values", test_num);
            valid = 1'b1;
            word0 = 16'h4500;
            word1 = 16'h003c;
            word2 = 16'h1c46;
            word3 = 16'h4000;
            word4 = 16'h4006;
            word5 = 16'hb1e6;
            word6 = 16'hac10;
            word7 = 16'h0a63;

            #1;


            check_outputs(16'h4F1C);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed High/Low Values with Carry", test_num);
            valid = 1'b1;
            word0 = 16'hF000;
            word1 = 16'h0F00;
            word2 = 16'h00F0;
            word3 = 16'h000F;
            word4 = 16'hAAAA;
            word5 = 16'h5555;
            word6 = 16'h1111;
            word7 = 16'hEEEE;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow Boundary Check", test_num);
            valid = 1'b1;
            word0 = 16'hFFFF;
            word1 = 16'h0001;
            word2 = 16'h0000;
            word3 = 16'h0000;
            word4 = 16'h0000;
            word5 = 16'h0000;
            word6 = 16'h0000;
            word7 = 16'h0000;

            #1;


            check_outputs(16'hFFFE);
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
