`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] DinShiftR;
    reg [15:0] a;
    reg clk;
    reg [17:0] cnt;
    reg videoinverso;
    reg vramdec;
    reg wr;
    wire [2:0] ACRAMVideo;
    wire [9:0] ASRAMVideo;
    wire cpuwait;
    wire cramce;
    wire scramoe;
    wire scramwr;
    wire sramce;
    wire video;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DinShiftR(DinShiftR),
        .a(a),
        .clk(clk),
        .cnt(cnt),
        .videoinverso(videoinverso),
        .vramdec(vramdec),
        .wr(wr),
        .ACRAMVideo(ACRAMVideo),
        .ASRAMVideo(ASRAMVideo),
        .cpuwait(cpuwait),
        .cramce(cramce),
        .scramoe(scramoe),
        .scramwr(scramwr),
        .sramce(sramce),
        .video(video)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            test_num = test_num + 1;
            DinShiftR = 8'h00;
            a = 16'h0000;
            cnt = 18'h00000;
            videoinverso = 0;
            vramdec = 0;
            wr = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            vramdec = 0;
            cnt = 18'h0AAAA;
            DinShiftR = 8'h01;
            videoinverso = 0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(3'b000, 10'h2AA, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            vramdec = 0;
            DinShiftR = 8'h01;
            videoinverso = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(3'b000, 10'h000, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            vramdec = 1;
            wr = 0;
            a = 16'h1234;
            @(posedge clk);
            #2;

            #1;


            check_outputs(3'b100, 10'h234, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            vramdec = 1;
            wr = 1;
            a = 16'h55AA;
            @(posedge clk);
            #2;

            #1;


            check_outputs(3'b101, 10'h1AA, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            vramdec = 0;
            cnt = 18'h3FFFF;
            DinShiftR = 8'h00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b000, 10'h3FF, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [2:0] expected_ACRAMVideo;
        input [9:0] expected_ASRAMVideo;
        input expected_cpuwait;
        input expected_cramce;
        input expected_scramoe;
        input expected_scramwr;
        input expected_sramce;
        input expected_video;
        begin
            if (expected_ACRAMVideo === (expected_ACRAMVideo ^ ACRAMVideo ^ expected_ACRAMVideo) &&
                expected_ASRAMVideo === (expected_ASRAMVideo ^ ASRAMVideo ^ expected_ASRAMVideo) &&
                expected_cpuwait === (expected_cpuwait ^ cpuwait ^ expected_cpuwait) &&
                expected_cramce === (expected_cramce ^ cramce ^ expected_cramce) &&
                expected_scramoe === (expected_scramoe ^ scramoe ^ expected_scramoe) &&
                expected_scramwr === (expected_scramwr ^ scramwr ^ expected_scramwr) &&
                expected_sramce === (expected_sramce ^ sramce ^ expected_sramce) &&
                expected_video === (expected_video ^ video ^ expected_video)) begin
                $display("PASS");
                $display("  Outputs: ACRAMVideo=%h, ASRAMVideo=%h, cpuwait=%b, cramce=%b, scramoe=%b, scramwr=%b, sramce=%b, video=%b",
                         ACRAMVideo, ASRAMVideo, cpuwait, cramce, scramoe, scramwr, sramce, video);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ACRAMVideo=%h, ASRAMVideo=%h, cpuwait=%b, cramce=%b, scramoe=%b, scramwr=%b, sramce=%b, video=%b",
                         expected_ACRAMVideo, expected_ASRAMVideo, expected_cpuwait, expected_cramce, expected_scramoe, expected_scramwr, expected_sramce, expected_video);
                $display("  Got:      ACRAMVideo=%h, ASRAMVideo=%h, cpuwait=%b, cramce=%b, scramoe=%b, scramwr=%b, sramce=%b, video=%b",
                         ACRAMVideo, ASRAMVideo, cpuwait, cramce, scramoe, scramwr, sramce, video);
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
        $dumpvars(0,DinShiftR, a, clk, cnt, videoinverso, vramdec, wr, ACRAMVideo, ASRAMVideo, cpuwait, cramce, scramoe, scramwr, sramce, video);
    end

endmodule
