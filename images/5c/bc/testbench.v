`timescale 1ns/1ps

module shiftreg8_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg rst;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shiftreg8 dut (
        .clk(clk),
        .d(d),
        .rst(rst),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            d = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset Behavior Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift All Ones (0xFF)", test_num);
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                d = 1;
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        reg [7:0] pattern;
        integer i;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift Pattern 0xAA", test_num);
            reset_dut();
            pattern = 8'hAA;
            for (i = 7; i >= 0; i = i - 1) begin
                d = pattern[i];
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase004;

        reg [7:0] pattern;
        integer i;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift Pattern 0x55", test_num);
            reset_dut();
            pattern = 8'h55;
            for (i = 7; i >= 0; i = i - 1) begin
                d = pattern[i];
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Overflow Test (Shift 12 bits)", test_num);
            reset_dut();


            for (i = 0; i < 8; i = i + 1) begin
                d = 1;
                @(posedge clk);
            end


            for (i = 0; i < 4; i = i + 1) begin
                d = 0;
                @(posedge clk);
            end

            #1;




            #1;





            check_outputs(8'hF0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single Bit Shift", test_num);
            reset_dut();
            d = 1;
            @(posedge clk);
            d = 0;
            repeat(7) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h80);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shiftreg8 Testbench");
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
        $dumpvars(0,clk, d, rst, q);
    end

endmodule
