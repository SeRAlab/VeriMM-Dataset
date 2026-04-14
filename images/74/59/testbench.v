`timescale 1ns/1ps

module parallel_load_reg_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    reg [5:0] d;
    reg load;
    wire [5:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    parallel_load_reg dut (
        .clk(clk),
        .clr(clr),
        .d(d),
        .load(load),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        clr = 1;
        load = 0;
        d = 6'b0;
        @(negedge clk);
        clr = 0;
        @(negedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Verifying Asynchronous Reset state", test_num);
        reset_dut();


        #1;



        check_outputs(6'b000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Verifying Basic Parallel Load (6'h2A)", test_num);
        reset_dut();
        d = 6'h2A;
        load = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(6'h2A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Verifying Load Enable Signal (Hold value)", test_num);
        reset_dut();


        d = 6'h15;
        load = 1;
        @(posedge clk);
        #2;


        d = 6'h3F;
        load = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(6'h15);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Verifying All Bits (6'b111111)", test_num);
        reset_dut();
        d = 6'b111111;
        load = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(6'b111111);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Verifying Asynchronous Clear Priority during Load", test_num);
        reset_dut();


        d = 6'h33;
        load = 1;
        @(posedge clk);
        #2;


        clr = 1;
        #1;
        #1;

        check_outputs(6'b000000);


        clr = 0;
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Verifying Consecutive Loads", test_num);
        reset_dut();

        load = 1;
        d = 6'h0A; @(posedge clk);
        d = 6'h1B; @(posedge clk);
        d = 6'h2C; @(posedge clk);
        #2;
        #1;

        check_outputs(6'h2C);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("parallel_load_reg Testbench");
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
        input [5:0] expected_q;
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
        $dumpvars(0,clk, clr, d, load, q);
    end

endmodule
