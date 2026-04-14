`timescale 1ns/1ps

module mux32_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg sel;
    wire [31:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux32 dut (
        .A(A),
        .B(B),
        .sel(sel),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Select A (sel=0)", test_num);
        A = 32'h12345678;
        B = 32'h87654321;
        sel = 0;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Select B (sel=1)", test_num);
        A = 32'h12345678;
        B = 32'h87654321;
        sel = 1;
        #1;

        check_outputs(32'h87654321);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Select A (sel=0) - Boundary All 1s", test_num);
        A = 32'hFFFFFFFF;
        B = 32'h00000000;
        sel = 0;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Select B (sel=1) - Boundary All 0s", test_num);
        A = 32'hFFFFFFFF;
        B = 32'h00000000;
        sel = 1;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Select A (sel=0) - Checkerboard", test_num);
        A = 32'h55555555;
        B = 32'hAAAAAAAA;
        sel = 0;
        #1;

        check_outputs(32'h55555555);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Select B (sel=1) - Reverse Checkerboard", test_num);
        A = 32'h55555555;
        B = 32'hAAAAAAAA;
        sel = 1;
        #1;

        check_outputs(32'hAAAAAAAA);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux32 Testbench");
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
        input [31:0] expected_Y;
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
