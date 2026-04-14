`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg [15:0] data_in;
    reg load;
    reg shift;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .areset(areset),
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .shift(shift),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

        begin
            areset = 1;
            load = 0;
            shift = 0;
            data_in = 0;
            #15;
            areset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Asynchronous Reset", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Parallel Load 0xABCD", test_num);
            reset_dut();
            @(posedge clk);
            data_in = 16'hABCD;
            load = 1;
            @(posedge clk);
            load = 0;
            #2;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Left Once", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 16'h0001;
            load = 1;
            @(posedge clk);
            load = 0;
            shift = 1;
            @(posedge clk);
            shift = 0;
            #2;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Left 4 bits", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 16'hF00F;
            load = 1;
            @(posedge clk);
            load = 0;
            shift = 1;
            repeat (4) @(posedge clk);
            shift = 0;
            #2;

            #1;


            check_outputs(16'h00F0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load Priority Check", test_num);
            reset_dut();
            @(posedge clk);
            data_in = 16'h5555;
            load = 1;
            shift = 1;
            @(posedge clk);
            load = 0;
            shift = 0;
            #2;

            #1;


            check_outputs(16'h5555);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift MSB Out", test_num);
            reset_dut();
            @(posedge clk);
            data_in = 16'h8000;
            load = 1;
            @(posedge clk);
            load = 0;
            shift = 1;
            @(posedge clk);
            shift = 0;
            #2;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
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
        input [15:0] expected_q;
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
        $dumpvars(0,areset, clk, data_in, load, shift, q);
    end

endmodule
