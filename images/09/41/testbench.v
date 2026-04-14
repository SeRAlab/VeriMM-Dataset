`timescale 1ns/1ps

module mux_2_to_1_tb;

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
    mux_2_to_1 dut (
        .A(A),
        .B(B),
        .sel(sel),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 16'h1234;
            B = 16'hABCD;
            sel = 1'b0;
            $display("Test %0d: Select A (sel=0) with basic values", test_num);
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 16'h1234;
            B = 16'hABCD;
            sel = 1'b1;
            $display("Test %0d: Select B (sel=1) with basic values", test_num);
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 16'hFFFF;
            B = 16'h0000;
            sel = 1'b0;
            $display("Test %0d: Select A (sel=0) - All ones vs All zeros", test_num);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 16'hFFFF;
            B = 16'h0000;
            sel = 1'b1;
            $display("Test %0d: Select B (sel=1) - All ones vs All zeros", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 16'hAAAA;
            B = 16'h5555;
            sel = 1'b0;
            $display("Test %0d: Select A (sel=0) - Alternating patterns", test_num);
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 16'hAAAA;
            B = 16'h5555;
            sel = 1'b1;
            $display("Test %0d: Select B (sel=1) - Alternating patterns", test_num);
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 16'h0001;
            B = 16'h8000;
            sel = 1'b0;
            $display("Test %0d: Select A (sel=0) - LSB vs MSB", test_num);
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 16'h0001;
            B = 16'h8000;
            sel = 1'b1;
            $display("Test %0d: Select B (sel=1) - LSB vs MSB", test_num);
            #1;

            check_outputs(16'h8000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_2_to_1 Testbench");
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
