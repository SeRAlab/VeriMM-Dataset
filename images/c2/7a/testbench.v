`timescale 1ns/1ps

module opModule_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] iA;
    reg [3:0] iB;
    reg iC;
    wire [3:0] oResult;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    opModule dut (
        .clk(clk),
        .iA(iA),
        .iB(iB),
        .iC(iC),
        .oResult(oResult)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            iA = 4'b0;
            iB = 4'b0;
            iC = 1'b0;
            @(negedge clk);


        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 001: Bitwise AND - All Zeroes");
            iA = 4'b0000;
            iB = 4'b0000;
            iC = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 002: Bitwise AND - All Ones");
            iA = 4'b1111;
            iB = 4'b1111;
            iC = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 003: Bitwise AND - Pattern Test");
            iA = 4'b1010;
            iB = 4'b1100;
            iC = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 004: Bitwise OR - Zeroes");
            iA = 4'b0000;
            iB = 4'b0000;
            iC = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 005: Bitwise OR - Pattern Test 1");
            iA = 4'b1010;
            iB = 4'b0101;
            iC = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 006: Bitwise OR - Pattern Test 2");
            iA = 4'b1100;
            iB = 4'b0110;
            iC = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 007: Bitwise AND - Masking");
            iA = 4'b1101;
            iB = 4'b0001;
            iC = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 008: Bitwise OR - Mixed Inputs");
            iA = 4'b1001;
            iB = 4'b1000;
            iC = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("opModule Testbench");
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
        input [3:0] expected_oResult;
        begin
            if (expected_oResult === (expected_oResult ^ oResult ^ expected_oResult)) begin
                $display("PASS");
                $display("  Outputs: oResult=%h",
                         oResult);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oResult=%h",
                         expected_oResult);
                $display("  Got:      oResult=%h",
                         oResult);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, iA, iB, iC, oResult);
    end

endmodule
