`timescale 1ns/1ps

module mux8to1_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] D;
    reg [2:0] S;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux8to1 dut (
        .D(D),
        .S(S),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select S=0, D[0]=1", test_num);
        S = 3'b000;
        D = 8'b00000001;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select S=1, D[1]=1", test_num);
        S = 3'b001;
        D = 8'b00000010;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select S=2, D[2]=1", test_num);
        S = 3'b010;
        D = 8'b00000100;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select S=3, D[3]=1", test_num);
        S = 3'b011;
        D = 8'b00001000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select S=4, D[4]=1", test_num);
        S = 3'b100;
        D = 8'b00010000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select S=5, D[5]=1", test_num);
        S = 3'b101;
        D = 8'b00100000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select S=6, D[6]=1", test_num);
        S = 3'b110;
        D = 8'b01000000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select S=7, D[7]=1", test_num);
        S = 3'b111;
        D = 8'b10000000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select S=0, D[0]=0, others=1", test_num);
        S = 3'b000;
        D = 8'b11111110;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select S=3, D[3]=0, others=1", test_num);
        S = 3'b011;
        D = 8'b11110111;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select S=7, D[7]=0, others=1", test_num);
        S = 3'b111;
        D = 8'b01111111;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All inputs 1, Select S=4", test_num);
        S = 3'b100;
        D = 8'b11111111;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All inputs 0, Select S=2", test_num);
        S = 3'b010;
        D = 8'b00000000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase014;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating pattern, Select S=5", test_num);
        S = 3'b101;
        D = 8'b10101010;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase015;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating pattern, Select S=4", test_num);
        S = 3'b100;
        D = 8'b10101010;
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
        $display("mux8to1 Testbench");
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
        testcase013();
        testcase014();
        testcase015();
        
        
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
