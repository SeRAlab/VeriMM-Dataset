`timescale 1ns/1ps

module shift_register_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [7:0] p_in;
    reg s_in;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_8bit dut (
        .clk(clk),
        .load(load),
        .p_in(p_in),
        .s_in(s_in),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            load = 1;
            p_in = 8'h00;
            s_in = 0;
            @(posedge clk);
            #1;
            load = 0;
            $display("DUT Reset: q = %h", q);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Parallel Load", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            p_in = 8'hA5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Single Serial Shift (In=1)", test_num);
            reset_dut();
            @(negedge clk);
            load = 0;
            s_in = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Multiple Serial Shifts (In sequence 1, 1, 0)", test_num);
            reset_dut();
            @(negedge clk);
            s_in = 1; @(posedge clk); #1;
            @(negedge clk);
            s_in = 1; @(posedge clk); #1;
            @(negedge clk);
            s_in = 0; @(posedge clk); #1;
            #1;

            check_outputs(8'h06);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Load Priority Over Shift", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            p_in = 8'h55;
            s_in = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Fill Register Serially (8 bits)", test_num);
            reset_dut();


            @(negedge clk); s_in = 1; @(posedge clk); #1;
            @(negedge clk); s_in = 0; @(posedge clk); #1;
            @(negedge clk); s_in = 1; @(posedge clk); #1;
            @(negedge clk); s_in = 1; @(posedge clk); #1;
            @(negedge clk); s_in = 0; @(posedge clk); #1;
            @(negedge clk); s_in = 0; @(posedge clk); #1;
            @(negedge clk); s_in = 0; @(posedge clk); #1;
            @(negedge clk); s_in = 1; @(posedge clk); #1;
            #1;

            check_outputs(8'hB1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Shift from Non-Zero Initial State", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            p_in = 8'hAA;
            @(posedge clk);
            #1;

            load = 0;
            s_in = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h54);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register_8bit Testbench");
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
        input [7:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, load, p_in, s_in, q);
    end

endmodule
