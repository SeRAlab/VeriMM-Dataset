`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] addr;
    reg clk;
    reg din;
    reg we;
    wire dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .addr(addr),
        .clk(clk),
        .din(din),
        .we(we),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        integer i;
        begin
            we = 0;
            addr = 0;
            din = 0;
            for (i = 0; i < 8; i = i + 1) begin
                @(negedge clk);
                we = 1;
                addr = i[2:0];
                din = 1'b0;
            end

            @(negedge clk);
            we = 0;
            addr = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Write 1 to addr 0 and read back", test_num);
        reset_dut();


        @(negedge clk);
        we = 1; addr = 3'd0; din = 1'b1;


        @(negedge clk);
        we = 0; addr = 3'd0;


        @(negedge clk);
        @(negedge clk);

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Check reset state (addr 7)", test_num);
        reset_dut();


        @(negedge clk);
        we = 0; addr = 3'd7;


        @(negedge clk);
        @(negedge clk);

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Overwrite addr 5 (1 -> 0)", test_num);
        reset_dut();


        @(negedge clk);
        we = 1; addr = 3'd5; din = 1'b1;

        @(negedge clk);
        we = 1; addr = 3'd5; din = 1'b0;


        @(negedge clk);
        we = 0; addr = 3'd5;


        @(negedge clk);
        @(negedge clk);

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Address isolation (Write to 2 and 3, read 2)", test_num);
        reset_dut();


        @(negedge clk);
        we = 1; addr = 3'd2; din = 1'b1;

        @(negedge clk);
        we = 1; addr = 3'd3; din = 1'b0;


        @(negedge clk);
        we = 0; addr = 3'd2;


        @(negedge clk);
        @(negedge clk);

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary check (Write/Read addr 7)", test_num);
        reset_dut();


        @(negedge clk);
        we = 1; addr = 3'd7; din = 1'b1;


        @(negedge clk);
        we = 0; addr = 3'd7;


        @(negedge clk);
        @(negedge clk);

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
        $display("dram_cell Testbench");
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
        input expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%b",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%b",
                         expected_dout);
                $display("  Got:      dout=%b",
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
        $dumpvars(0,addr, clk, din, we, dout);
    end

endmodule
