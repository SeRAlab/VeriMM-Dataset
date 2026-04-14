`timescale 1ns/1ps

module shift_register_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    reg si;
    wire so;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_16bit dut (
        .clk(clk),
        .en(en),
        .rst(rst),
        .si(si),
        .so(so)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            en = 0;
            si = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        integer i;
        begin
            test_num = 1;
            $display("Testcase %0d: Shifting 16 ones", test_num);
            reset_dut();
            en = 1;
            si = 1;
            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            $display("Testcase %0d: Single 1 followed by 15 zeros", test_num);
            reset_dut();
            en = 1;
            si = 1;
            @(posedge clk);
            #1;
            si = 0;
            for (i = 0; i < 15; i = i + 1) begin
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase %0d: Single 0 followed by 15 ones", test_num);
            reset_dut();
            en = 1;
            si = 0;
            @(posedge clk);
            #1;
            si = 1;
            for (i = 0; i < 15; i = i + 1) begin
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase %0d: Testing Enable signal functionality", test_num);
            reset_dut();


            en = 1;
            si = 1;
            @(posedge clk);
            #1;


            en = 0;
            si = 0;
            repeat(5) @(posedge clk);
            #1;


            en = 1;
            for (i = 0; i < 15; i = i + 1) begin
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verify Reset functionality", test_num);
            reset_dut();


            en = 1;
            si = 1;
            repeat(8) @(posedge clk);
            #1;


            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Testcase %0d: Continuous shifting (32 cycles)", test_num);
            reset_dut();
            en = 1;


            si = 0;
            for (i = 0; i < 31; i = i + 1) begin
                @(posedge clk);
                #1;
            end
            si = 1;
            @(posedge clk);
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
        $display("shift_register_16bit Testbench");
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
        input expected_so;
        begin
            if (expected_so === (expected_so ^ so ^ expected_so)) begin
                $display("PASS");
                $display("  Outputs: so=%b",
                         so);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: so=%b",
                         expected_so);
                $display("  Got:      so=%b",
                         so);
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
        $dumpvars(0,clk, en, rst, si, so);
    end

endmodule
