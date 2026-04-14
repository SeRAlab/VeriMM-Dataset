`timescale 1ns/1ps

module mux4to1_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A0;
    reg [3:0] A1;
    reg [3:0] A2;
    reg [3:0] A3;
    reg S0;
    reg S1;
    reg VGND;
    reg VPWR;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux4to1 dut (
        .A0(A0),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .S0(S0),
        .S1(S1),
        .VGND(VGND),
        .VPWR(VPWR),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = 1;
        VPWR = 1; VGND = 0;
        A0 = 4'b0001; A1 = 4'b0000; A2 = 4'b0000; A3 = 4'b0000;
        S1 = 0; S0 = 0;
        $display("Test %0d: Select A0 (S=00), A0=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        VPWR = 1; VGND = 0;
        A0 = 4'b0000; A1 = 4'b0000; A2 = 4'b0000; A3 = 4'b0000;
        S1 = 0; S0 = 0;
        $display("Test %0d: Select A0 (S=00), A0=0", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        VPWR = 1; VGND = 0;
        A0 = 4'b0000; A1 = 4'b0001; A2 = 4'b0000; A3 = 4'b0000;
        S1 = 0; S0 = 1;
        $display("Test %0d: Select A1 (S=01), A1=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        VPWR = 1; VGND = 0;
        A0 = 4'b0000; A1 = 4'b0000; A2 = 4'b0000; A3 = 4'b0000;
        S1 = 0; S0 = 1;
        $display("Test %0d: Select A1 (S=01), A1=0", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        VPWR = 1; VGND = 0;
        A0 = 4'b0000; A1 = 4'b0000; A2 = 4'b0001; A3 = 4'b0000;
        S1 = 1; S0 = 0;
        $display("Test %0d: Select A2 (S=10), A2=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        VPWR = 1; VGND = 0;
        A0 = 4'b0000; A1 = 4'b0000; A2 = 4'b0000; A3 = 4'b0000;
        S1 = 1; S0 = 0;
        $display("Test %0d: Select A2 (S=10), A2=0", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        VPWR = 1; VGND = 0;
        A0 = 4'b0000; A1 = 4'b0000; A2 = 4'b0000; A3 = 4'b0001;
        S1 = 1; S0 = 1;
        $display("Test %0d: Select A3 (S=11), A3=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        VPWR = 1; VGND = 0;
        A0 = 4'b0000; A1 = 4'b0000; A2 = 4'b0000; A3 = 4'b0000;
        S1 = 1; S0 = 1;
        $display("Test %0d: Select A3 (S=11), A3=0", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        VPWR = 1; VGND = 0;

        A0 = 4'b0001; A1 = 4'b1111; A2 = 4'b1111; A3 = 4'b1111;
        S1 = 0; S0 = 0;
        $display("Test %0d: Interference check (S=00, A0=1, others=F)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        VPWR = 1; VGND = 0;

        A0 = 4'b1110; A1 = 4'b0000; A2 = 4'b0000; A3 = 4'b0000;
        S1 = 0; S0 = 0;
        $display("Test %0d: Multi-bit input check (S=00, A0=4'hE, expect 0)", test_num);
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
        $display("mux4to1 Testbench");
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
        input expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%b",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b",
                         expected_Y);
                $display("  Got:      Y=%b",
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
