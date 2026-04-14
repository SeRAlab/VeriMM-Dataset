`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg load;
    reg s_in;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .d(d),
        .load(load),
        .s_in(s_in),
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
            load <= 1'b1;
            d <= 8'h00;
            s_in <= 1'b0;
            @(posedge clk);
            load <= 1'b0;
            d <= 8'h00;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            @(posedge clk);
            load <= 1'b1;
            d <= 8'hA5;
            @(posedge clk);
            load <= 1'b0;

            #1;
            $display("Testcase %0d: Parallel Load 0xA5", test_num);
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            @(posedge clk);
            load <= 1'b1;
            d <= 8'hFF;
            @(posedge clk);


            load <= 1'b0;
            s_in <= 1'b0;
            @(posedge clk);

            #1;
            $display("Testcase %0d: Load 0xFF and Shift Right once (s_in=0)", test_num);
            #1;

            check_outputs(8'h7F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            @(posedge clk);
            load <= 1'b1;
            d <= 8'h00;
            @(posedge clk);


            load <= 1'b0;
            s_in <= 1'b1;
            @(posedge clk);

            #1;
            $display("Testcase %0d: Load 0x00 and Shift Right once (s_in=1)", test_num);
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            reset_dut();


            @(posedge clk);
            load <= 1'b1;
            d <= 8'h00;
            @(posedge clk);


            load <= 1'b0;
            s_in <= 1'b1;
            for(i=0; i<4; i=i+1) begin
                @(posedge clk);
            end

            #1;
            $display("Testcase %0d: Shift in four 1s", test_num);
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            reset_dut();


            @(posedge clk);
            load <= 1'b1;
            d <= 8'hAA;
            @(posedge clk);


            load <= 1'b0;
            s_in <= 1'b0;
            for(i=0; i<8; i=i+1) begin
                @(posedge clk);
            end

            #1;
            $display("Testcase %0d: Clear register by shifting 8 times with s_in=0", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();


            @(posedge clk);
            load <= 1'b1;
            d <= 8'h5A;
            s_in <= 1'b1;
            @(posedge clk);

            #1;
            $display("Testcase %0d: Priority Check - Load 0x5A while s_in=1", test_num);
            #1;

            check_outputs(8'h5A);
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
        $dumpvars(0,clk, d, load, s_in, q);
    end

endmodule
