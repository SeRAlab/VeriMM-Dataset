`timescale 1ns/1ps

module debounce_tb;

    // Testbench signals (sequential circuit)
    reg but;
    reg clk;
    wire debounced;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    debounce dut (
        .but(but),
        .clk(clk),
        .debounced(debounced)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        but = 0;

        repeat(20) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Initial Press Response (Immediate)", test_num);
        reset_dut();

        but = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Ignore bounces after initial press", test_num);
        reset_dut();

        but = 1;
        @(posedge clk);


        repeat(5) begin
            but = ~but;
            @(posedge clk);
        end

        #1;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Release after 10 stable cycles", test_num);
        reset_dut();

        but = 1;
        @(posedge clk);
        repeat(15) @(posedge clk);

        but = 0;
        repeat(12) @(posedge clk);

        #1;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Glitch rejection (pulse < 10 cycles)", test_num);
        reset_dut();

        but = 1;
        @(posedge clk);
        repeat(15) @(posedge clk);


        but = 0;
        repeat(5) @(posedge clk);
        but = 1;
        repeat(10) @(posedge clk);

        #1;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Full press and release sequence", test_num);
        reset_dut();


        but = 1;
        @(posedge clk);
        repeat(15) @(posedge clk);


        but = 0;
        repeat(15) @(posedge clk);


        but = 1;
        repeat(15) @(posedge clk);

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
        $display("debounce Testbench");
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
        input expected_debounced;
        begin
            if (expected_debounced === (expected_debounced ^ debounced ^ expected_debounced)) begin
                $display("PASS");
                $display("  Outputs: debounced=%b",
                         debounced);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: debounced=%b",
                         expected_debounced);
                $display("  Got:      debounced=%b",
                         debounced);
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
        $dumpvars(0,but, clk, debounced);
    end

endmodule
