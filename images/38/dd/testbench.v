`timescale 1ns/1ps

module mux8_to_1_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] d;
    reg [2:0] s;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux8_to_1 dut (
        .d(d),
        .s(s),
        .y(y)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Select s=000, expect d[0]=1", test_num);
        s = 3'b000;
        d = 8'b00000001;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Select s=001, expect d[1]=1", test_num);
        s = 3'b001;
        d = 8'b00000010;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Select s=010, expect d[2]=1", test_num);
        s = 3'b010;
        d = 8'b00000100;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Select s=011, expect d[3]=1", test_num);
        s = 3'b011;
        d = 8'b00001000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Select s=100, expect d[4]=1", test_num);
        s = 3'b100;
        d = 8'b00010000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Select s=101, expect d[5]=1", test_num);
        s = 3'b101;
        d = 8'b00100000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Select s=110, expect d[6]=1", test_num);
        s = 3'b110;
        d = 8'b01000000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Select s=111, expect d[7]=1", test_num);
        s = 3'b111;
        d = 8'b10000000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Select s=000, expect d[0]=0 (others high)", test_num);
        s = 3'b000;
        d = 8'b11111110;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Select s=111, expect d[7]=0 (others high)", test_num);
        s = 3'b111;
        d = 8'b01111111;
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
        $display("mux8_to_1 Testbench");
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
        input expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%b",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%b",
                         expected_y);
                $display("  Got:      y=%b",
                         y);
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
