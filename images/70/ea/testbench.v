`timescale 1ns/1ps

module shift_register_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg load;
    reg si;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_8bit dut (
        .clk(clk),
        .d(d),
        .load(load),
        .si(si),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            load <= 1;
            d <= 8'h00;
            si <= 0;
            @(posedge clk);
            load <= 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Parallel Load 8'hA5", test_num);
            reset_dut();

            @(posedge clk);
            load <= 1;
            d <= 8'hA5;
            @(posedge clk);
            load <= 0;

            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Serial Shift All 1s", test_num);
            reset_dut();

            load <= 0;
            si <= 1;
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
            end

            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load and Shift Left 4 positions", test_num);
            reset_dut();


            @(posedge clk);
            load <= 1;
            d <= 8'h0F;
            @(posedge clk);
            load <= 0;
            si <= 0;


            for (i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
            end

            #1;
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase004;

        reg [7:0] pattern;
        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Serial Input Pattern 10110001", test_num);
            reset_dut();

            pattern = 8'b10110001;
            load <= 0;

            for (i = 7; i >= 0; i = i - 1) begin
                si <= pattern[i];
                @(posedge clk);
            end

            #1;
            #1;

            check_outputs(8'hb1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load Priority Over Shift", test_num);
            reset_dut();

            @(posedge clk);
            load <= 1;
            d <= 8'hCC;
            si <= 1;
            @(posedge clk);
            load <= 0;

            #1;
            #1;

            check_outputs(8'hCC);
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
        $dumpvars(0,clk, d, load, si, q);
    end

endmodule
