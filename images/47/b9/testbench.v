`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] D;
    reg [2:0] S;
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;
    wire Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .S(S),
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .Z(Z)
    );
    task power_on;

    begin
        VPWR = 1'b1;
        VGND = 1'b0;
        VPB  = 1'b1;
        VNB  = 1'b0;
    end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        power_on();
        D = 8'b00000001;
        S = 3'b000;
        $display("Test %0d: Select D[0]=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        power_on();
        D = 8'b00000010;
        S = 3'b001;
        $display("Test %0d: Select D[1]=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        power_on();
        D = 8'b00000100;
        S = 3'b010;
        $display("Test %0d: Select D[2]=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        power_on();
        D = 8'b00001000;
        S = 3'b011;
        $display("Test %0d: Select D[3]=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        power_on();
        D = 8'b00010000;
        S = 3'b100;
        $display("Test %0d: Select D[4]=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        power_on();
        D = 8'b00100000;
        S = 3'b101;
        $display("Test %0d: Select D[5]=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        power_on();
        D = 8'b01000000;
        S = 3'b110;
        $display("Test %0d: Select D[6]=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        power_on();
        D = 8'b10000000;
        S = 3'b111;
        $display("Test %0d: Select D[7]=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        power_on();
        D = 8'b11111111;
        S = 3'b100;
        $display("Test %0d: All 1s, S=4", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        power_on();
        D = 8'b00000000;
        S = 3'b010;
        $display("Test %0d: All 0s, S=2", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        power_on();
        D = 8'b10101010;
        S = 3'b001;
        $display("Test %0d: Pattern 0xAA, S=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        power_on();
        D = 8'b10101010;
        S = 3'b000;
        $display("Test %0d: Pattern 0xAA, S=0", test_num);
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
        $display("top_module Testbench");
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
        testcase011();
        testcase012();
        
        
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
        input expected_Z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Z=%b",
                         Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%b",
                         expected_Z);
                $display("  Got:      Z=%b",
                         Z);
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
