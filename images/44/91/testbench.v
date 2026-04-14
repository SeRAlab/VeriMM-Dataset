`timescale 1ns/1ps

module USR_8_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] PI;
    reg SI_L;
    reg SI_R;
    reg clk;
    reg dir;
    reg load;
    reg rst;
    reg shift;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    USR_8 dut (
        .PI(PI),
        .SI_L(SI_L),
        .SI_R(SI_R),
        .clk(clk),
        .dir(dir),
        .load(load),
        .rst(rst),
        .shift(shift),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            load = 0;
            shift = 0;
            dir = 0;
            SI_L = 0;
            SI_R = 0;
            PI = 8'h00;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Synchronous Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Parallel Load 0xA5", test_num);
            reset_dut();
            PI = 8'hA5;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Left Shift Sequence", test_num);
            reset_dut();

            PI = 8'h01; load = 1; @(posedge clk);
            #1 load = 0; shift = 1; dir = 1;


            SI_L = 1; @(posedge clk);

            SI_L = 0; @(posedge clk);

            SI_L = 1; @(posedge clk);

            #1 #1;
 check_outputs(8'h0D);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Right Shift Sequence", test_num);
            reset_dut();

            PI = 8'h80; load = 1; @(posedge clk);
            #1 load = 0; shift = 1; dir = 0;


            SI_R = 1; @(posedge clk);

            SI_R = 0; @(posedge clk);

            SI_R = 1; @(posedge clk);

            #1 #1;
 check_outputs(8'hB0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Hold Value Check", test_num);
            reset_dut();
            PI = 8'h55; load = 1; @(posedge clk);
            #1 load = 0; shift = 0;
            repeat(3) @(posedge clk);
            #1 #1;
 check_outputs(8'h55);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Priority Check (Reset > Load)", test_num);
            reset_dut();
            PI = 8'hFF; load = 1; rst = 1;
            @(posedge clk);
            #1 rst = 0; load = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Priority Check (Load > Shift)", test_num);
            reset_dut();
            PI = 8'hAA; load = 1; shift = 1; dir = 1; SI_L = 0;
            @(posedge clk);
            #1 load = 0; shift = 0;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Complex Direction Switching", test_num);
            reset_dut();

            PI = 8'h0F; load = 1; @(posedge clk);
            #1 load = 0; shift = 1;


            dir = 1; SI_L = 0; @(posedge clk);


            dir = 0; SI_R = 1; @(posedge clk);

            #1 #1;
 check_outputs(8'h8F);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("USR_8 Testbench");
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
        input [7:0] expected_Q;
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
        $dumpvars(0,PI, SI_L, SI_R, clk, dir, load, rst, shift, Q);
    end

endmodule
