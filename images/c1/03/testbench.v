`timescale 1ns/1ps

module adapter_tb;

    // Testbench signals (sequential circuit)
    reg IO_Addr_Strobe;
    reg [31:0] IO_Address;
    reg [3:0] IO_Byte_Enable;
    reg IO_Read_Strobe;
    reg [31:0] IO_Write_Data;
    reg IO_Write_Strobe;
    reg ckdr;
    reg ckmb;
    reg [2:0] dbg_out;
    reg [3:0] page;
    reg reset;
    reg [255:0] srdat;
    reg srdy;
    wire [31:0] IO_Read_Data;
    wire IO_Ready;
    wire [28:0] sa;
    wire [31:0] smsk;
    wire srd;
    wire [255:0] swdat;
    wire swr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adapter dut (
        .IO_Addr_Strobe(IO_Addr_Strobe),
        .IO_Address(IO_Address),
        .IO_Byte_Enable(IO_Byte_Enable),
        .IO_Read_Strobe(IO_Read_Strobe),
        .IO_Write_Data(IO_Write_Data),
        .IO_Write_Strobe(IO_Write_Strobe),
        .ckdr(ckdr),
        .ckmb(ckmb),
        .dbg_out(dbg_out),
        .page(page),
        .reset(reset),
        .srdat(srdat),
        .srdy(srdy),
        .IO_Read_Data(IO_Read_Data),
        .IO_Ready(IO_Ready),
        .sa(sa),
        .smsk(smsk),
        .srd(srd),
        .swdat(swdat),
        .swr(swr)
    );

    // Clock generation (10ns period)
    initial begin
        ckdr = 0;
        forever #5 ckdr = ~ckdr;
    end

        task reset_dut;

        begin
            reset = 1;
            IO_Addr_Strobe = 0;
            IO_Read_Strobe = 0;
            IO_Write_Strobe = 0;
            IO_Address = 0;
            IO_Byte_Enable = 0;
            IO_Write_Data = 0;
            page = 0;
            srdat = 0;
            srdy = 0;
            dbg_out = 0;
            repeat (5) @(posedge ckmb);
            reset = 0;
            repeat (2) @(posedge ckmb);
        end
        endtask
    task drive_srdy;

        input is_read;
        begin

            wait (srd || swr);
            repeat (2) @(posedge ckdr);
            srdy = 1;
            @(posedge ckdr);
            srdy = 0;
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Basic Write to Slot 0", test_num);

            IO_Address = 32'h0000_1000;
            page = 4'hA;
            IO_Write_Data = 32'hDEADBEEF;
            IO_Byte_Enable = 4'hF;
            IO_Addr_Strobe = 1;
            IO_Write_Strobe = 1;

            fork
                drive_srdy(0);
                begin
                    @(posedge ckmb);
                    IO_Addr_Strobe = 0;
                    IO_Write_Strobe = 0;
                    wait(IO_Ready);
                end
            join



            #1;




            check_outputs(32'h0, 1'b1, {4'hA, 25'h20}, 32'h0000000F, 1'b0, {224'h0, 32'hDEADBEEF}, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Basic Read from Slot 1", test_num);

            IO_Address = 32'h0000_2004;
            page = 4'hB;
            IO_Addr_Strobe = 1;
            IO_Read_Strobe = 1;


            srdat = 256'h0;
            srdat[63:32] = 32'hCAFEBABE;

            fork
                drive_srdy(1);
                begin
                    @(posedge ckmb);
                    IO_Addr_Strobe = 0;
                    IO_Read_Strobe = 0;
                    wait(IO_Ready);
                end
            join


            #1;



            check_outputs(32'hCAFEBABE, 1'b1, {4'hB, 25'h40}, 32'h0, 1'b0, 256'h0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Partial Write to Slot 7", test_num);

            IO_Address = 32'h0000_001C;
            page = 4'h5;
            IO_Write_Data = 32'h12345678;
            IO_Byte_Enable = 4'h9;
            IO_Addr_Strobe = 1;
            IO_Write_Strobe = 1;

            fork
                drive_srdy(0);
                begin
                    @(posedge ckmb);
                    IO_Addr_Strobe = 0;
                    IO_Write_Strobe = 0;
                    wait(IO_Ready);
                end
            join


            #1;



            check_outputs(32'h0, 1'b1, {4'h5, 25'h0}, 32'h90000000, 1'b0, {32'h12345678, 224'h0}, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Read from Slot 6", test_num);

            IO_Address = 32'h0000_0018;
            page = 4'h1;
            IO_Addr_Strobe = 1;
            IO_Read_Strobe = 1;

            srdat = 0;
            srdat[223:192] = 32'h55AA55AA;

            fork
                drive_srdy(1);
                begin
                    @(posedge ckmb);
                    IO_Addr_Strobe = 0;
                    IO_Read_Strobe = 0;
                    wait(IO_Ready);
                end
            join

            #1;


            check_outputs(32'h55AA55AA, 1'b1, {4'h1, 25'h0}, 32'h0, 1'b0, 256'h0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adapter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [31:0] expected_IO_Read_Data;
        input expected_IO_Ready;
        input [28:0] expected_sa;
        input [31:0] expected_smsk;
        input expected_srd;
        input [255:0] expected_swdat;
        input expected_swr;
        begin
            if (expected_IO_Read_Data === (expected_IO_Read_Data ^ IO_Read_Data ^ expected_IO_Read_Data) &&
                expected_IO_Ready === (expected_IO_Ready ^ IO_Ready ^ expected_IO_Ready) &&
                expected_sa === (expected_sa ^ sa ^ expected_sa) &&
                expected_smsk === (expected_smsk ^ smsk ^ expected_smsk) &&
                expected_srd === (expected_srd ^ srd ^ expected_srd) &&
                expected_swdat === (expected_swdat ^ swdat ^ expected_swdat) &&
                expected_swr === (expected_swr ^ swr ^ expected_swr)) begin
                $display("PASS");
                $display("  Outputs: IO_Read_Data=%h, IO_Ready=%b, sa=%h, smsk=%h, srd=%b, swdat=%h, swr=%b",
                         IO_Read_Data, IO_Ready, sa, smsk, srd, swdat, swr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IO_Read_Data=%h, IO_Ready=%b, sa=%h, smsk=%h, srd=%b, swdat=%h, swr=%b",
                         expected_IO_Read_Data, expected_IO_Ready, expected_sa, expected_smsk, expected_srd, expected_swdat, expected_swr);
                $display("  Got:      IO_Read_Data=%h, IO_Ready=%b, sa=%h, smsk=%h, srd=%b, swdat=%h, swr=%b",
                         IO_Read_Data, IO_Ready, sa, smsk, srd, swdat, swr);
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
        $dumpvars(0,IO_Addr_Strobe, IO_Address, IO_Byte_Enable, IO_Read_Strobe, IO_Write_Data, IO_Write_Strobe, ckdr, ckmb, dbg_out, page, reset, srdat, srdy, IO_Read_Data, IO_Ready, sa, smsk, srd, swdat, swr);
    end

endmodule
