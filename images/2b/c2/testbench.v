`timescale 1ns/1ps

module audio_mux_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg sel;
    wire [15:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_mux dut (
        .A(A),
        .B(B),
        .sel(sel),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select Input A (A=0000, B=FFFF, sel=0)", test_num);
            A = 16'h0000;
            B = 16'hFFFF;
            sel = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select Input B (A=0000, B=FFFF, sel=1)", test_num);
            A = 16'h0000;
            B = 16'hFFFF;
            sel = 1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select Input A with patterns (A=AAAA, B=5555, sel=0)", test_num);
            A = 16'hAAAA;
            B = 16'h5555;
            sel = 0;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select Input B with patterns (A=AAAA, B=5555, sel=1)", test_num);
            A = 16'hAAAA;
            B = 16'h5555;
            sel = 1;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Select Input A with random data (A=1234, B=ABCD, sel=0)", test_num);
            A = 16'h1234;
            B = 16'hABCD;
            sel = 0;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Select Input B with random data (A=1234, B=ABCD, sel=1)", test_num);
            A = 16'h1234;
            B = 16'hABCD;
            sel = 1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Both inputs same (A=7777, B=7777, sel=0)", test_num);
            A = 16'h7777;
            B = 16'h7777;
            sel = 0;
            #1;

            check_outputs(16'h7777);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Both inputs same (A=7777, B=7777, sel=1)", test_num);
            A = 16'h7777;
            B = 16'h7777;
            sel = 1;
            #1;

            check_outputs(16'h7777);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("audio_mux Testbench");
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
        input [15:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
