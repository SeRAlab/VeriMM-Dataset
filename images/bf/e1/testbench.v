`timescale 1ns/1ps

module icontrol_tb;

    // Testbench signals (sequential circuit)
    reg [14:0] i_brd_ints;
    reg i_clk;
    reg [31:0] i_proc_bus;
    reg i_reset;
    reg i_wr;
    wire o_interrupt;
    wire [31:0] o_proc_bus;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    icontrol dut (
        .i_brd_ints(i_brd_ints),
        .i_clk(i_clk),
        .i_proc_bus(i_proc_bus),
        .i_reset(i_reset),
        .i_wr(i_wr),
        .o_interrupt(o_interrupt),
        .o_proc_bus(o_proc_bus)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

        task reset_dut;

        begin
            i_reset = 1;
            i_wr = 0;
            i_proc_bus = 0;
            i_brd_ints = 0;
            @(posedge i_clk);
            #2 i_reset = 0;
            @(posedge i_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power-on Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable GIE and Masks", test_num);
            reset_dut();
            @(posedge i_clk);
            i_wr = 1;
            i_proc_bus = 32'h8FFF_0000;
            @(posedge i_clk);
            i_wr = 0;
            @(posedge i_clk);
            #1;

            check_outputs(1'b0, 32'h8FFF_0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Hardware Interrupt without GIE/Mask", test_num);
            reset_dut();
            i_brd_ints = 15'h0001;
            @(posedge i_clk);
            i_brd_ints = 15'h0000;
            @(posedge i_clk);

            #1;


            check_outputs(1'b0, 32'h0000_0001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Successful Interrupt Generation", test_num);
            reset_dut();

            i_wr = 1;
            i_proc_bus = 32'h8020_0000;
            @(posedge i_clk);
            i_wr = 0;

            i_brd_ints = 15'h0020;
            @(posedge i_clk);
            i_brd_ints = 0;
            @(posedge i_clk);

            #1;


            check_outputs(1'b1, 32'h8020_0020);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Clearing Interrupts (W1C)", test_num);
            reset_dut();

            i_wr = 1;
            i_proc_bus = 32'h8001_0000;
            @(posedge i_clk);

            i_brd_ints = 15'h0001;
            @(posedge i_clk);
            i_brd_ints = 0;
            @(posedge i_clk);

            i_proc_bus = 32'h8001_0001;
            i_wr = 1;
            @(posedge i_clk);
            i_wr = 0;
            @(posedge i_clk);

            #1;


            check_outputs(1'b0, 32'h8001_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: GIE Master Switch Logic", test_num);
            reset_dut();

            i_wr = 1;
            i_proc_bus = 32'h0001_0000;
            @(posedge i_clk);

            i_brd_ints = 15'h0001;
            @(posedge i_clk);
            i_brd_ints = 0;
            @(posedge i_clk);

            if (o_interrupt !== 1'b0) $display("Fail Mid-Test: GIE off failed");


            i_proc_bus = 32'h8001_0000;
            i_wr = 1;
            @(posedge i_clk);
            i_wr = 0;
            @(posedge i_clk);

            #1;


            check_outputs(1'b1, 32'h8001_0001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("icontrol Testbench");
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
        input expected_o_interrupt;
        input [31:0] expected_o_proc_bus;
        begin
            if (expected_o_interrupt === (expected_o_interrupt ^ o_interrupt ^ expected_o_interrupt) &&
                expected_o_proc_bus === (expected_o_proc_bus ^ o_proc_bus ^ expected_o_proc_bus)) begin
                $display("PASS");
                $display("  Outputs: o_interrupt=%b, o_proc_bus=%h",
                         o_interrupt, o_proc_bus);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_interrupt=%b, o_proc_bus=%h",
                         expected_o_interrupt, expected_o_proc_bus);
                $display("  Got:      o_interrupt=%b, o_proc_bus=%h",
                         o_interrupt, o_proc_bus);
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
        $dumpvars(0,i_brd_ints, i_clk, i_proc_bus, i_reset, i_wr, o_interrupt, o_proc_bus);
    end

endmodule
