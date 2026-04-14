`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data;
    reg sclr;
    reg shift_en;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data(data),
        .sclr(sclr),
        .shift_en(shift_en),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            sclr = 1;
            shift_en = 0;
            data = 0;
            @(posedge clk);
            #1;
            sclr = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Reset", test_num);
            reset_dut();

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift Single Bit (1)", test_num);
            reset_dut();
            shift_en = 1;
            data = 1;
            @(posedge clk);
            #1;
            shift_en = 0;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift 4 Bits (1011)", test_num);
            reset_dut();
            shift_en = 1;

            data = 1; @(posedge clk); #1;
            data = 0; @(posedge clk); #1;
            data = 1; @(posedge clk); #1;
            data = 1; @(posedge clk); #1;

            shift_en = 0;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift Enable Inhibition", test_num);
            reset_dut();


            shift_en = 1;
            data = 1;
            @(posedge clk); #1;


            shift_en = 0;
            data = 0;
            @(posedge clk); #1;
            @(posedge clk); #1;

            #1;


            check_outputs(4'b0001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sync Clear Priority", test_num);
            reset_dut();


            shift_en = 1;
            data = 1;
            @(posedge clk); #1;
            @(posedge clk); #1;


            sclr = 1;
            shift_en = 1;
            data = 1;
            @(posedge clk); #1;

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Continuous Shift (5 bits)", test_num);
            reset_dut();
            shift_en = 1;


            data = 1; @(posedge clk); #1;
            data = 1; @(posedge clk); #1;
            data = 0; @(posedge clk); #1;
            data = 1; @(posedge clk); #1;
            data = 0; @(posedge clk); #1;

            shift_en = 0;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift Out Data", test_num);
            reset_dut();
            shift_en = 1;


            data = 1;
            repeat(4) begin @(posedge clk); #1; end


            data = 0;
            repeat(2) begin @(posedge clk); #1; end

            #1;


            check_outputs(4'b1100);
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
        input [3:0] expected_q;
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
        $dumpvars(0,clk, data, sclr, shift_en, q);
    end

endmodule
