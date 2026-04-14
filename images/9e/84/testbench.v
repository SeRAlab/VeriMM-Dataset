`timescale 1ns/1ps

module register_8bit_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [7:0] D;
    reg Load;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_8bit dut (
        .Clk(Clk),
        .D(D),
        .Load(Load),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            D = 8'h00;
            Load = 1;
            @(posedge Clk);
            #1;
            Load = 0;
            $display("DUT Reset to initial state (Q=00)");
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Running testcase%03d: Basic Load 0xA5", test_num);

            D = 8'hA5;
            Load = 1;
            @(posedge Clk);
            #1;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Running testcase%03d: Load Disabled", test_num);

            D = 8'hFF;
            Load = 0;
            @(posedge Clk);
            #1;


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Running testcase%03d: Hold value", test_num);


            D = 8'h55;
            Load = 1;
            @(posedge Clk);
            #1;


            D = 8'hAA;
            Load = 0;
            @(posedge Clk);
            #1;


            #1;



            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Running testcase%03d: Load All Ones (0xFF)", test_num);

            D = 8'hFF;
            Load = 1;
            @(posedge Clk);
            #1;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Running testcase%03d: Consecutive Loads", test_num);


            D = 8'h12;
            Load = 1;
            @(posedge Clk);
            #1;


            D = 8'h34;
            Load = 1;
            @(posedge Clk);
            #1;

            #1;


            check_outputs(8'h34);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Running testcase%03d: Timing check (Falling Edge)", test_num);

            @(negedge Clk);
            D = 8'hEE;
            Load = 1;
            #1;


            #1;



            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register_8bit Testbench");
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
        $dumpvars(0,Clk, D, Load, Q);
    end

endmodule
