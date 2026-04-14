`timescale 1ns/1ps

module aeMB2_brcc_tb;

    // Testbench signals (sequential circuit)
    reg dena;
    reg gclk;
    reg gpha;
    reg grst;
    reg iena;
    reg [5:0] opc_of;
    reg [31:0] opd_of;
    reg [4:0] ra_of;
    reg [4:0] rd_of;
    wire [1:0] bra_ex;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aeMB2_brcc dut (
        .dena(dena),
        .gclk(gclk),
        .gpha(gpha),
        .grst(grst),
        .iena(iena),
        .opc_of(opc_of),
        .opd_of(opd_of),
        .ra_of(ra_of),
        .rd_of(rd_of),
        .bra_ex(bra_ex)
    );

    // Clock generation (10ns period)
    initial begin
        gclk = 0;
        forever #5 gclk = ~gclk;
    end

        task reset_dut;

        begin
            grst = 1;
            dena = 0;
            iena = 0;
            gpha = 0;
            opc_of = 0;
            opd_of = 0;
            ra_of = 0;
            rd_of = 0;
            repeat(2) @(posedge gclk);
            #1 grst = 0;
            @(posedge gclk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            dena = 1;
            opc_of = 6'h27;
            opd_of = 32'h0000_1000;
            rd_of = 5'b00000;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            dena = 1;
            opc_of = 6'h26;
            rd_of  = 5'b00000;
            opd_of = 32'h0000_0000;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            dena = 1;
            opc_of = 6'h26;
            rd_of  = 5'b00000;
            opd_of = 32'h0000_FFFF;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            dena = 1;
            opc_of = 6'h26;
            rd_of  = 5'b00001;
            opd_of = 32'hABC12345;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            dena = 1;
            opc_of = 6'h26;
            rd_of  = 5'b00010;
            opd_of = 32'h8000_0000;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            dena = 1;
            opc_of = 6'h26;
            rd_of  = 5'b00101;
            opd_of = 32'h0000_0005;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            dena = 0;
            opc_of = 6'h27;
            opd_of = 32'h0000_1000;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            dena = 1;
            opc_of = 6'h00;
            opd_of = 32'h0000_0000;
            #1;

            check_outputs(2'b00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aeMB2_brcc Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [1:0] expected_bra_ex;
        begin
            if (expected_bra_ex === (expected_bra_ex ^ bra_ex ^ expected_bra_ex)) begin
                $display("PASS");
                $display("  Outputs: bra_ex=%h",
                         bra_ex);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bra_ex=%h",
                         expected_bra_ex);
                $display("  Got:      bra_ex=%h",
                         bra_ex);
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
        $dumpvars(0,dena, gclk, gpha, grst, iena, opc_of, opd_of, ra_of, rd_of, bra_ex);
    end

endmodule
