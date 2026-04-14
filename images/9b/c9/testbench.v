`timescale 1ns/1ps

module adder_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    wire [15:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_16bit dut (
        .A(A),
        .B(B),
        .SUM(SUM)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All zeros (0 + 0)", test_num);
            A = 16'h0000;
            B = 16'h0000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple addition (1 + 2)", test_num);
            A = 16'h0001;
            B = 16'h0002;
            #1;

            check_outputs(16'h0003);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large values without carry-out (0x1234 + 0x4321)", test_num);
            A = 16'h1234;
            B = 16'h4321;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition producing all ones (0xAAAA + 0x5555)", test_num);
            A = 16'hAAAA;
            B = 16'h5555;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum value and zero (0xFFFF + 0x0000)", test_num);
            A = 16'hFFFF;
            B = 16'h0000;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overflow check (0xFFFF + 0x0001)", test_num);
            A = 16'hFFFF;
            B = 16'h0001;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Carry ripple across bytes (0x00FF + 0x0001)", test_num);
            A = 16'h00FF;
            B = 16'h0001;
            #1;

            check_outputs(16'h0100);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mid-point overflow (0x8000 + 0x8000)", test_num);
            A = 16'h8000;
            B = 16'h8000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bit boundary test (0x7FFF + 0x0001)", test_num);
            A = 16'h7FFF;
            B = 16'h0001;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random arbitrary values (0xABCD + 0x1234)", test_num);
            A = 16'hABCD;
            B = 16'h1234;
            #1;

            check_outputs(16'hBE01);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_16bit Testbench");
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
        input [15:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: SUM=%h",
                         SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SUM=%h",
                         expected_SUM);
                $display("  Got:      SUM=%h",
                         SUM);
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
