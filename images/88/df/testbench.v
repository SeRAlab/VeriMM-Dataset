`timescale 1ns/1ps

module shift_register_4bit_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [3:0] D;
    reg Shift;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_4bit dut (
        .Clk(Clk),
        .D(D),
        .Shift(Shift),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Shift = 0;
            D = 4'b0000;
            @(posedge Clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Parallel Load 4'b1010", test_num);
            reset_dut();

            D = 4'b1010;
            Shift = 0;
            @(posedge Clk);
            #1;

            #1;


            check_outputs(4'b1010);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift Right Once (1011 -> 0101)", test_num);
            reset_dut();


            D = 4'b1011;
            Shift = 0;
            @(posedge Clk);
            #1;


            Shift = 1;
            @(posedge Clk);
            #1;

            #1;


            check_outputs(4'b0101);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift Right Twice (1100 -> 0011)", test_num);
            reset_dut();


            D = 4'b1100;
            Shift = 0;
            @(posedge Clk);
            #1;


            Shift = 1;
            @(posedge Clk);
            #1;

            @(posedge Clk);
            #1;

            #1;


            check_outputs(4'b0011);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift Right Four Times (1111 -> 0000)", test_num);
            reset_dut();


            D = 4'b1111;
            Shift = 0;
            @(posedge Clk);
            #1;


            Shift = 1;
            repeat(4) @(posedge Clk);
            #1;

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift Mode Ignores D Input", test_num);
            reset_dut();


            D = 4'b1001;
            Shift = 0;
            @(posedge Clk);
            #1;


            Shift = 1;
            D = 4'b1111;
            @(posedge Clk);
            #1;


            #1;



            check_outputs(4'b0100);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register_4bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [3:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
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
        $dumpvars(0,Clk, D, Shift, Q);
    end

endmodule
