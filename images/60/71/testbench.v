`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg rst_n;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .d(d),
        .rst_n(rst_n),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            d = 0;
            @(negedge clk);
            rst_n = 1;
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

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift in All Ones", test_num);
            reset_dut();
            d = 1;
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        reg [7:0] pattern;
        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift Specific Pattern (10110011)", test_num);
            reset_dut();
            pattern = 8'b10110011;










            d = 1; @(posedge clk); #1;
            d = 1; @(posedge clk); #1;
            d = 0; @(posedge clk); #1;
            d = 0; @(posedge clk); #1;
            d = 1; @(posedge clk); #1;
            d = 1; @(posedge clk); #1;
            d = 0; @(posedge clk); #1;
            d = 1; @(posedge clk); #1;

            #1;


            check_outputs(8'b10110011);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Bit Propagation", test_num);
            reset_dut();


            d = 1;
            @(posedge clk);
            #1;


            d = 0;
            for (i = 0; i < 7; i = i + 1) begin
                @(posedge clk);
                #1;
            end


            #1;



            check_outputs(8'h01);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Partial Fill and Clear", test_num);
            reset_dut();


            d = 1;
            for (i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
                #1;
            end


            d = 0;
            for (i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
                #1;
            end


            #1;



            check_outputs(8'h0F);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset Mid-operation", test_num);
            reset_dut();


            d = 1;
            @(posedge clk); #1;
            @(posedge clk); #1;


            rst_n = 0;
            #2;
            #1;

            check_outputs(8'h00);


            rst_n = 1;
            @(posedge clk);
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
        $dumpvars(0,clk, d, rst_n, q);
    end

endmodule
