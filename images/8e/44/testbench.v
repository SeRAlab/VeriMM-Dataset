`timescale 1ns/1ps

module binary_counter_load_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data;
    reg enable;
    reg load;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_counter_load dut (
        .clk(clk),
        .data(data),
        .enable(enable),
        .load(load),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        load <= 1;
        enable <= 0;
        data <= 4'b0000;
        @(posedge clk);
        #1;
        load <= 0;
        data <= 4'b0000;
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Synchronous Load (Data = 4'hA)");
        reset_dut();
        test_num = test_num + 1;

        load <= 1;
        data <= 4'hA;
        @(posedge clk);
        #1;

        #1;


        check_outputs(4'hA);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Single Increment (0 to 1)");
        reset_dut();
        test_num = test_num + 1;

        load <= 0;
        enable <= 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(4'h1);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Disable (Counter should hold value)");
        reset_dut();
        test_num = test_num + 1;


        load <= 1;
        data <= 4'h5;
        @(posedge clk);


        #1;
        load <= 0;
        enable <= 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(4'h5);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Wrap-around (15 to 0)");
        reset_dut();
        test_num = test_num + 1;


        load <= 1;
        data <= 4'hF;
        @(posedge clk);


        #1;
        load <= 0;
        enable <= 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(4'h0);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Load Priority (Load and Enable both high)");
        reset_dut();
        test_num = test_num + 1;



        load <= 1;
        data <= 4'h7;
        enable <= 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(4'h7);
    end
        endtask

    task testcase006;

    begin
        $display("Running testcase006: Multiple Increments (0 to 3)");
        reset_dut();
        test_num = test_num + 1;

        load <= 0;
        enable <= 1;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #1;

        #1;


        check_outputs(4'h3);
    end
        endtask

    task testcase007;

    begin
        $display("Running testcase007: Load after incrementing");
        reset_dut();
        test_num = test_num + 1;


        enable <= 1;
        @(posedge clk);
        @(posedge clk);


        #1;
        load <= 1;
        data <= 4'hC;
        @(posedge clk);
        #1;

        #1;


        check_outputs(4'hC);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_counter_load Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [3:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, data, enable, load, count);
    end

endmodule
