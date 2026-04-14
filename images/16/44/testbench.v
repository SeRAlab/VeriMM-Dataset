`timescale 1ns/1ps

module FlashMemoryCell_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg D;
    reg E;
    reg P;
    reg R;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    FlashMemoryCell dut (
        .CLK(CLK),
        .D(D),
        .E(E),
        .P(P),
        .R(R),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            @(posedge CLK);
            P <= 0;
            E <= 1;
            R <= 0;
            D <= 0;
            @(posedge CLK);
            E <= 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Erase and Read", test_num);
            reset_dut();

            @(posedge CLK);
            E <= 1;
            R <= 1;
            @(posedge CLK);
            E <= 0;
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Program 1 and Read", test_num);
            reset_dut();

            @(posedge CLK);
            D <= 1;
            P <= 1;
            @(posedge CLK);
            P <= 0;
            R <= 1;
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Program 0 and Read", test_num);
            reset_dut();


            @(posedge CLK);
            D <= 1; P <= 1;
            @(posedge CLK);
            D <= 0; P <= 1;
            @(posedge CLK);
            P <= 0;
            R <= 1;
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Read Enable Check (R=0)", test_num);
            reset_dut();

            @(posedge CLK);
            D <= 1;
            P <= 1;
            @(posedge CLK);
            P <= 0;
            R <= 0;
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Erase Priority Over Program", test_num);
            reset_dut();

            @(posedge CLK);
            D <= 1;
            P <= 1;
            E <= 1;
            @(posedge CLK);
            P <= 0;
            E <= 0;
            R <= 1;
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Retention", test_num);
            reset_dut();

            @(posedge CLK);
            D <= 1;
            P <= 1;
            @(posedge CLK);
            P <= 0;
            repeat(2) @(posedge CLK);
            R <= 1;
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("FlashMemoryCell Testbench");
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
        input expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%b",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b",
                         expected_Q);
                $display("  Got:      Q=%b",
                         Q);
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
        $dumpvars(0,CLK, D, E, P, R, Q);
    end

endmodule
