`timescale 1ns/1ps

module VGA_CRT_tb;

    // Testbench signals (sequential circuit)
    reg CE;
    reg CLK;
    reg WR;
    reg addr;
    reg [7:0] din;
    wire [11:0] cursorpos;
    wire [7:0] dout;
    wire oncursor;
    wire [15:0] scraddr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    VGA_CRT dut (
        .CE(CE),
        .CLK(CLK),
        .WR(WR),
        .addr(addr),
        .din(din),
        .cursorpos(cursorpos),
        .dout(dout),
        .oncursor(oncursor),
        .scraddr(scraddr)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            CE = 0;
            CLK = 0;
            WR = 0;
            addr = 0;
            din = 0;
            #10;
            CE = 1;
            #10;
        end
        endtask
    task write_register;

        input [7:0] reg_idx;
        input [7:0] value;
        begin
            @(posedge CLK);
            CE = 1; WR = 1; addr = 0; din = reg_idx;
            @(posedge CLK);
            CE = 1; WR = 1; addr = 1; din = value;
            @(posedge CLK);
            WR = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Setting Cursor Position", test_num);
            reset_dut();

            write_register(8'd14, 8'h0A);
            write_register(8'd15, 8'hBC);




            #10;
            #1;

            check_outputs(12'hABC, 8'hBC, oncursor, scraddr);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %02d: Setting Screen Start Address", test_num);
            reset_dut();

            write_register(8'd12, 8'h12);
            write_register(8'd13, 8'h34);

            #10;
            #1;

            check_outputs(cursorpos, 8'h34, oncursor, 16'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Toggle Cursor Visibility", test_num);
            reset_dut();


            write_register(8'd10, 8'h00);
            #5;
            if (oncursor !== 1'b1) $display("Note: Visibility logic might differ (Bit 5=0)");


            write_register(8'd10, 8'h20);
            #10;
            #1;

            check_outputs(cursorpos, 8'h20, 1'b0, scraddr);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Register Readback", test_num);
            reset_dut();


            write_register(8'd15, 8'h55);


            @(posedge CLK);
            addr = 0; WR = 1; din = 8'd15;
            @(posedge CLK);
            addr = 1; WR = 0;

            #10;
            #1;

            check_outputs(cursorpos, 8'h55, oncursor, scraddr);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Clock Enable Check", test_num);
            reset_dut();


            @(posedge CLK);
            CE = 0; WR = 1; addr = 0; din = 8'd14;
            @(posedge CLK);
            addr = 1; din = 8'hFF;
            @(posedge CLK);
            WR = 0; CE = 1;

            #10;

            if (cursorpos == 12'hF00) begin
                $display("FAIL: Write occurred while CE was low");
                fail_count = fail_count + 1;
            end else begin
                $display("PASS: Register unchanged as expected");
                pass_count = pass_count + 1;
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("VGA_CRT Testbench");
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
        input [11:0] expected_cursorpos;
        input [7:0] expected_dout;
        input expected_oncursor;
        input [15:0] expected_scraddr;
        begin
            if (expected_cursorpos === (expected_cursorpos ^ cursorpos ^ expected_cursorpos) &&
                expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_oncursor === (expected_oncursor ^ oncursor ^ expected_oncursor) &&
                expected_scraddr === (expected_scraddr ^ scraddr ^ expected_scraddr)) begin
                $display("PASS");
                $display("  Outputs: cursorpos=%h, dout=%h, oncursor=%b, scraddr=%h",
                         cursorpos, dout, oncursor, scraddr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cursorpos=%h, dout=%h, oncursor=%b, scraddr=%h",
                         expected_cursorpos, expected_dout, expected_oncursor, expected_scraddr);
                $display("  Got:      cursorpos=%h, dout=%h, oncursor=%b, scraddr=%h",
                         cursorpos, dout, oncursor, scraddr);
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
        $dumpvars(0,CE, CLK, WR, addr, din, cursorpos, dout, oncursor, scraddr);
    end

endmodule
