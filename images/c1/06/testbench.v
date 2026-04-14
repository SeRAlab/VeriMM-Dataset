`timescale 1ns/1ps

module aeMB2_bsft_tb;

    // Testbench signals (sequential circuit)
    reg dena;
    reg gclk;
    reg gpha;
    reg grst;
    reg [1:0] imm_of;
    reg [31:0] opa_of;
    reg [31:0] opb_of;
    reg [5:0] opc_of;
    wire [31:0] bsf_mx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aeMB2_bsft dut (
        .dena(dena),
        .gclk(gclk),
        .gpha(gpha),
        .grst(grst),
        .imm_of(imm_of),
        .opa_of(opa_of),
        .opb_of(opb_of),
        .opc_of(opc_of),
        .bsf_mx(bsf_mx)
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
        opa_of = 32'h0;
        opb_of = 32'h0;
        imm_of = 2'b00;
        opc_of = 6'b0;
        gpha = 0;
        repeat(2) @(posedge gclk);
        #1 grst = 0;
        @(posedge gclk);
    end
        endtask
    task testcase001;

    begin
        $display("Testcase001: Logical Left Shift (SLL) - 0x00000001 << 4");
        reset_dut();
        dena = 1;
        opa_of = 32'h0000_0001;
        opb_of = 32'd4;
        imm_of = 2'b00;
        @(posedge gclk);
        #2;
        #1;

        check_outputs(32'h0000_0010);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase002: Logical Right Shift (SRL) - 0x80000000 >> 4");
        reset_dut();
        dena = 1;
        opa_of = 32'h8000_0000;
        opb_of = 32'd4;
        imm_of = 2'b01;
        @(posedge gclk);
        #2;
        #1;

        check_outputs(32'h0800_0000);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase003: Arithmetic Right Shift (SRA) - 0xF0000000 >>> 4 (Sign Extension)");
        reset_dut();
        dena = 1;
        opa_of = 32'hF000_0000;
        opb_of = 32'd4;
        imm_of = 2'b10;
        @(posedge gclk);
        #2;
        #1;

        check_outputs(32'hFF00_0000);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase004: Arithmetic Right Shift (SRA) - 0x40000000 >>> 2 (No Sign Extension)");
        reset_dut();
        dena = 1;
        opa_of = 32'h4000_0000;
        opb_of = 32'd2;
        imm_of = 2'b10;
        @(posedge gclk);
        #2;
        #1;

        check_outputs(32'h1000_0000);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase005: Logical Left Shift (SLL) - Max Shift 31");
        reset_dut();
        dena = 1;
        opa_of = 32'h0000_0001;
        opb_of = 32'd31;
        imm_of = 2'b00;
        @(posedge gclk);
        #2;
        #1;

        check_outputs(32'h8000_0000);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase006: Shift by Zero");
        reset_dut();
        dena = 1;
        opa_of = 32'hDEADBEEF;
        opb_of = 32'd0;
        imm_of = 2'b01;
        @(posedge gclk);
        #2;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase007: Data Enable (dena) Low - Output should not update");
        reset_dut();

        dena = 1; opa_of = 32'hAAAA_AAAA; opb_of = 0; imm_of = 0;
        @(posedge gclk);

        dena = 0; opa_of = 32'hFFFF_FFFF; opb_of = 32'd8; imm_of = 0;
        @(posedge gclk);
        #2;
        #1;

        check_outputs(32'hAAAA_AAAA);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aeMB2_bsft Testbench");
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
        input [31:0] expected_bsf_mx;
        begin
            if (expected_bsf_mx === (expected_bsf_mx ^ bsf_mx ^ expected_bsf_mx)) begin
                $display("PASS");
                $display("  Outputs: bsf_mx=%h",
                         bsf_mx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bsf_mx=%h",
                         expected_bsf_mx);
                $display("  Got:      bsf_mx=%h",
                         bsf_mx);
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
        $dumpvars(0,dena, gclk, gpha, grst, imm_of, opa_of, opb_of, opc_of, bsf_mx);
    end

endmodule
