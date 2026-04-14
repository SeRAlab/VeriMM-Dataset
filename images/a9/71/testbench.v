`timescale 1ns/1ps

module bidirectional_shift_reg_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg din;
    reg rst_n;
    reg shift_left;
    reg shift_right;
    wire [7:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bidirectional_shift_reg dut (
        .clk(clk),
        .din(din),
        .rst_n(rst_n),
        .shift_left(shift_left),
        .shift_right(shift_right),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        din = 0;
        shift_left = 0;
        shift_right = 0;
        @(posedge clk);
        #1 rst_n = 1;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset and Idle Check", test_num);
        reset_dut();

        @(posedge clk);
        @(posedge clk);
        #1 #1;
 check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Shift Left 8 times (Input 1)", test_num);
        reset_dut();
        shift_left = 1;
        din = 1;
        repeat (8) @(posedge clk);
        shift_left = 0;
        #1 #1;
 check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    integer i;
    reg [7:0] data_to_shift;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Shift Right (Pattern 10101010)", test_num);
        reset_dut();
        data_to_shift = 8'b10101010;
        shift_right = 1;


        for (i = 0; i < 8; i = i + 1) begin
            din = data_to_shift[i];
            @(posedge clk);
        end
        shift_right = 0;
        #1 #1;
 check_outputs(8'b10101010);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating Shift Left and Right", test_num);
        reset_dut();


        shift_left = 1; din = 1; @(posedge clk);

        shift_left = 1; din = 1; @(posedge clk);


        shift_left = 0; shift_right = 1; din = 0; @(posedge clk);

        shift_right = 0;
        #1 #1;
 check_outputs(8'h01);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Holding Value with No Shift Signals", test_num);
        reset_dut();


        shift_left = 1;
        repeat (4) begin
            din = 1; @(posedge clk);
            din = 0; @(posedge clk);
        end


        shift_left = 0;
        shift_right = 0;
        din = 1;
        repeat (4) @(posedge clk);

        #1 #1;
 check_outputs(8'h55);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Clear Register via Shift Right 0s", test_num);
        reset_dut();


        shift_left = 1; din = 1; repeat(8) @(posedge clk);


        shift_left = 0;
        shift_right = 1;
        din = 0;
        repeat(4) @(posedge clk);

        shift_right = 0;
        #1 #1;
 check_outputs(8'h0F);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bidirectional_shift_reg Testbench");
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
        input [7:0] expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
        $dumpvars(0,clk, din, rst_n, shift_left, shift_right, dout);
    end

endmodule
