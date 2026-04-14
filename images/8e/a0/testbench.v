`timescale 1ns/1ps

module mux_8to1_tb;

    // Testbench signals (combinational circuit)
    reg D0;
    reg D1;
    reg D2;
    reg D3;
    reg D4;
    reg D5;
    reg D6;
    reg D7;
    reg [2:0] S;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_8to1 dut (
        .D0(D0),
        .D1(D1),
        .D2(D2),
        .D3(D3),
        .D4(D4),
        .D5(D5),
        .D6(D6),
        .D7(D7),
        .S(S),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest %0d: Select S=000, D0=1", test_num);
        {D0, D1, D2, D3, D4, D5, D6, D7} = 8'b10000000;
        S = 3'b000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest %0d: Select S=001, D1=1", test_num);
        {D0, D1, D2, D3, D4, D5, D6, D7} = 8'b01000000;
        S = 3'b001;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest %0d: Select S=010, D2=1", test_num);
        {D0, D1, D2, D3, D4, D5, D6, D7} = 8'b00100000;
        S = 3'b010;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest %0d: Select S=011, D3=1", test_num);
        {D0, D1, D2, D3, D4, D5, D6, D7} = 8'b00010000;
        S = 3'b011;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest %0d: Select S=100, D4=1", test_num);
        {D0, D1, D2, D3, D4, D5, D6, D7} = 8'b00001000;
        S = 3'b100;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest %0d: Select S=101, D5=1", test_num);
        {D0, D1, D2, D3, D4, D5, D6, D7} = 8'b00000100;
        S = 3'b101;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTest %0d: Select S=110, D6=1", test_num);
        {D0, D1, D2, D3, D4, D5, D6, D7} = 8'b00000010;
        S = 3'b110;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTest %0d: Select S=111, D7=1", test_num);
        {D0, D1, D2, D3, D4, D5, D6, D7} = 8'b00000001;
        S = 3'b111;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("\nTest %0d: Select S=000, D0=0 (Others 1)", test_num);
        {D0, D1, D2, D3, D4, D5, D6, D7} = 8'b01111111;
        S = 3'b000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("\nTest %0d: Select S=111, D7=0 (Others 1)", test_num);
        {D0, D1, D2, D3, D4, D5, D6, D7} = 8'b11111110;
        S = 3'b111;
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
        $display("mux_8to1 Testbench");
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
