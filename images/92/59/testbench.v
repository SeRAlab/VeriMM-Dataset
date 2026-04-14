`timescale 1ns/1ps

module shift_register_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg load;
    reg reset;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_16bit dut (
        .clk(clk),
        .d(d),
        .load(load),
        .reset(reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            d = 16'h0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Parallel Load (0xABCD)", test_num);
            reset_dut();
            load = 1;
            d = 16'hABCD;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Left Once (0x0001 -> 0x0002)", test_num);
            reset_dut();

            load = 1;
            d = 16'h0001;
            @(posedge clk);
            #1;

            load = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Left 4 Times (0x000F -> 0x00F0)", test_num);
            reset_dut();

            load = 1;
            d = 16'h000F;
            @(posedge clk);
            #1;

            load = 0;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h00F0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift to MSB (0x0001 -> 0x8000)", test_num);
            reset_dut();
            load = 1;
            d = 16'h0001;
            @(posedge clk);
            #1;
            load = 0;
            repeat(15) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift out MSB (0x8000 -> 0x0000)", test_num);
            reset_dut();
            load = 1;
            d = 16'h8000;
            @(posedge clk);
            #1;
            load = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Priority Check (Load overrides shift)", test_num);
            reset_dut();
            load = 1;
            d = 16'hAAAA;
            @(posedge clk);
            #1;

            d = 16'h5555;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 0xFFFF and Shift", test_num);
            reset_dut();
            load = 1;
            d = 16'hFFFF;
            @(posedge clk);
            #1;
            load = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register_16bit Testbench");
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
        $dumpvars(0,clk, d, load, reset, q);
    end

endmodule
